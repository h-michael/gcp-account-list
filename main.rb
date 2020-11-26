# frozen_string_literal: true
require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'

  gem "google-api-client"
end

require 'googleauth'
require 'google/apis/cloudresourcemanager_v1'

resource = ENV['GCP_PROJECT_ID']
service = Google::Apis::CloudresourcemanagerV1::CloudResourceManagerService.new
service.authorization = Google::Auth.get_application_default(['https://www.googleapis.com/auth/cloud-platform'])
request_body = Google::Apis::CloudresourcemanagerV1::GetIamPolicyRequest.new
response = service.get_project_iam_policy(resource, request_body)

members = {}

JSON.parse(response.to_json)["bindings"].each do |v|
  v["members"].each do |m|
    if members[m] == nil
      members[m] = []
    end
    members[m].push(v["role"])
  end
end

members.each do |k, v|
  if k.split(":").first == "user"
    pp "#{k},#{v.join("|")}"
  end
end
