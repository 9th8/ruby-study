#!/usr/bin/env ruby

["net/http", "uri", "json"].each { |m| require m }

class Request # {{{
  attr_reader :stack, :name, :image
  def initialize
    @api, @access_key, @secret_key, @project_id, @stack, @name, @image =
      ENV.values_at("RANCHER_API", "RANCHER_ACCESS_KEY", "RANCHER_SECRET_KEY", "RANCHER_PROJECT_ID",
        "RANCHER_STACK", "SERVICE_NAME", "IMAGE_VERSION")
  end

  def get(endpoint)
    @uri = URI.parse("#{@api}/v1/projects/#{@project_id}/#{endpoint}")
    Net::HTTP.start(@uri.host, @uri.port, use_ssl: true) do |http|
      req = Net::HTTP::Get.new(@uri)
      req.basic_auth(@access_key, @secret_key)
      JSON.parse(http.request(req).body)["data"][0]
    end
  end

  def post(endpoint, payload)
    @uri = URI.parse("#{@api}/v2-beta/projects/#{@project_id}/services/#{endpoint}")
    Net::HTTP.start(@uri.host, @uri.port, use_ssl: true) do |http|
      req = Net::HTTP::Post.new(@uri)
      req.body = payload
      req.content_type = "application/json"
      req.basic_auth(@access_key, @secret_key)
      http.request(req).body
    end
  end

  def upgraded?(endpoint, desired_state)
    state = ""
    try = 5
    until state == desired_state
      @uri = URI.parse("#{@api}/v1/projects/#{@project_id}/services/#{endpoint}")
      Net::HTTP.start(@uri.host, @uri.port, use_ssl: true) do |http|
        req = Net::HTTP::Get.new(@uri)
        req.basic_auth(@access_key, @secret_key)
        state = JSON.parse(http.request(req).body)["state"]
      end
      puts "\t[...check #{6 - try} of 5] service status is '#{state}'"
      unless state == desired_state
        ((try -= 1) > 0) ? (sleep 15) : (raise "Failure: Could not complere upgrade. Check Rancher state.")
      end
    end
    true
  end

  def finish_upgrade(endpoint)
    puts "Finishing upgrade..."
    post("#{endpoint}/?action=finishupgrade", nil)
    upgraded?(endpoint, "active")
  end
rescue => e
  puts e
end # }}}

service = Request.new

puts "Upgrading service '#{service.name}' in stack '#{service.stack}'."

Request.new.get("environments?name=#{service.stack}") => stack_data
raise "FAILURE: stack: #{service.stack} not found." if stack_data.empty?

service_data = service.get("/service?name=#{service.name}&environmentId=#{stack_data["id"]}")
raise "FAILURE: service: #{service.name} not found." if service_data.empty?

launch_config = service_data["launchConfig"].merge("imageUuid" => "docker:#{service.image}")
payload = {inServiceStrategy: {batchSize: 1, intervalMillis: 2000, startFirst: false,
                               launchConfig: launch_config}}.to_json
Request.new.post("#{service_data["id"]}/?action=upgrade", payload)

service.finish_upgrade(service_data["id"]) if service.upgraded?(service_data["id"], "upgraded")
puts "SUCCESS: Service '#{service.name}' was upgraded!"
