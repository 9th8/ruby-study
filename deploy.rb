#!/usr/bin/env ruby

require "net/http"
require "json"

if ENV["DEBUG"]
  ["debug", "debug/open", "dotenv"].each { |m| require m }
  Dotenv.load(".env")
end

class Request # {{{
  attr_reader :stack, :name, :image

  # Собирает параметры сценария, переданные в переменных окружения.
  def initialize
    @api = ENV["RANCHER_API"]
    @access_key = ENV["RANCHER_ACCESS_KEY"]
    @secret_key = ENV["RANCHER_SECRET_KEY"]
    @project_id = ENV["RANCHER_PROJECT_ID"]
    @stack = ENV["RANCHER_STACK"]
    @name = ENV["SERVICE_NAME"]
    @image = ENV["IMAGE_VERSION"]
  end

  # Отправляет Get/Post запросы на указанный эндпоинт.
  def request(method, endpoint, payload = nil)
    uri = URI.parse("#{@api}/v2-beta/projects/#{@project_id}/#{endpoint}")
    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      req = Net::HTTP.const_get(method).new(uri)
      req.body = payload.to_json if payload
      req.content_type = "application/json"
      req.basic_auth(@access_key, @secret_key)
      JSON.parse(http.request(req).body)
    end
  end

  # Проверяет, выполнен ли апгрейд сервиса? Делает 5 попыток в перерывом в 15 секунд.
  def upgraded?(endpoint, desired_state)
    state = ""
    5.times do |try|
      state = request("Get", "services/#{endpoint}")["state"]
      puts "\t[...check #{try + 1} of 5] service status is '#{state}'"
      return true if state == desired_state
      sleep 15 unless try == 4
    end
    raise "FAILURE: Could not complete upgrade. Check Rancher state manually."
  end

  # Формирует запрос на завершение апгрейда сервиса.
  def finish_upgrade(endpoint)
    puts "Finishing upgrade..."
    request("Post", "services/#{endpoint}/?action=finishupgrade")
    upgraded?(endpoint, "active")
  end
end # }}}

service = Request.new

puts "Upgrading service '#{service.name}' in stack '#{service.stack}'."

# Для полученного имени стэка запрашиваем конфиг, чтобы извлечь его Id.
stack_id = service.request("Get", "stack?name=#{service.stack}")["data"][0]["id"]
raise ArgumentError, "FAILURE: stack '#{service.stack}' not found." if stack_id.empty?

# Запрашиваем конфиг сервиса.
service_data = service.request("Get", "services?name=#{service.name}&stackId=#{stack_id}")["data"][0]
raise ArgumentError, "FAILURE: service '#{service.name}' not found." if service_data.empty?

# Меняем версию образа в 'launchConfig' сервиса и отправляем запрос на апгрейд сервиса.
launch_config = service_data["launchConfig"].merge("imageUuid" => "docker:#{service.image}")
payload = {inServiceStrategy: {batchSize: 1, intervalMillis: 2000, startFirst: false, launchConfig: launch_config}}
service.request("Post", "services/#{service_data["id"]}/?action=upgrade", payload)

# Проверяем, успешен ли апгрейд и завершаем его если всё ок.
service.finish_upgrade(service_data["id"]) if service.upgraded?(service_data["id"], "upgraded")
puts "SUCCESS: service '#{service.name}' was upgraded!"
