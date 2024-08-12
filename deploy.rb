#!/usr/bin/env ruby
# Апгрейдит сервис в ранчере 1.6 согласно полученным в ENV параметрам.
#
# "+.+"+.+"+.+"+.+"+.+"+.+"+.+"+.+"+.+"+.+"+.+"+.+"+.+"+.+"+.+"+.+"+.+"+.+"+.+"+.+"+.+"+.+"+.+"+.+"+.+"+.+"+.+"+.+"+.+"

["debug", "debug/open"].each { |m| require m if ENV["DEBUG"] }
(require "dotenv" if ENV["DOTENV"]) && Dotenv.load(".env")

require "net/http"
require "json"

module Request
  def initialize
    @api = ENV["RANCHER_API"]
    @access_key = ENV["RANCHER_ACCESS_KEY"]
    @secret_key = ENV["RANCHER_SECRET_KEY"]
    @project_id = ENV["RANCHER_PROJECT_ID"]
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
end

class Service
  include Request
  attr_reader :stack, :name

  def initialize
    @stack = ENV["RANCHER_STACK"]
    @name = ENV["SERVICE_NAME"]
    @image = ENV["IMAGE_VERSION"]
    @service_id, @service_data, @payload = nil, nil, nil
  end

  # Получает ID стека по имени стэка.
  def get_stack_id
    response = request("Get", "stack?name=#{@stack}")["data"].first["id"]
    raise ArgumentError, "FAILURE: stack '#{@stack}' not found." if response.nil? || response.empty?
    response
  end

  # Получает данные сервиса по имени сервиса и стека.
  def get_service_details
    @service_data = request("Get", "services?name=#{@name}&stackId=#{get_stack_id}")["data"].first
    raise ArgumentError, "FAILURE: service '#{@name}' not found." if @service_data.nil? || @service_data.empty?
    @service_id = @service_data["id"]
  end

  # Меняет версию образа в 'launchConfig' сервиса.
  def prepare_payload
    launch_config = @service_data["launchConfig"].merge("imageUuid" => "docker:#{@image}")
    @payload = {inServiceStrategy: {batchSize: 1, intervalMillis: 2000, startFirst: false, launchConfig: launch_config}}
  end

  # Отправляет запрос на апгрейд сервиса.
  def send_upgrade_request = request("Post", "services/#{@service_id}/?action=upgrade", @payload)

  # Проверяет соответствие состояния сервиса желаемому. Делает 5 попыток в перерывом в 15 секунд.
  def state_is?(desired_state)
    state = ""
    5.times do |try|
      sleep 15 if try > 0
      state = request("Get", "services/#{@service_id}")["state"]
      puts "\t[...check #{try + 1} of 5] service status is '#{state}'"
      return true if state == desired_state
    end
    abort "FAILURE: Could not complete upgrade. Check Rancher state manually."
  end

  # Формирует запрос на завершение апгрейда сервиса.
  def finish_upgrade
    puts "Finishing upgrade..."
    request("Post", "services/#{@service_id}/?action=finishupgrade")
  end
end

service = Service.new

puts "Upgrading service '#{service.name}' in stack '#{service.stack}'."

service.get_service_details
service.prepare_payload
service.send_upgrade_request
service.finish_upgrade if service.state_is?("upgraded")

puts "SUCCESS: service '#{service.name}' was upgraded!" if service.state_is?("active")
