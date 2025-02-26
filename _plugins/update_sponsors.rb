require "down"
require 'net/http'

module Jekyll
    QUERY = {"query":"{viewer { ... on Sponsorable {sponsors(first: 32) {totalCount nodes { ... on User { login } ... on Organization { login }}}}}}"}
    Jekyll::Hooks.register :site, :after_init do |site|
        if ENV["GITHUB_TOKEN"]
            puts "Fetching sponsors..."
            res = Net::HTTP.post(URI.parse("https://api.github.com/graphql"), QUERY.to_json, {"Authorization" => "bearer " + ENV["GITHUB_TOKEN"], "Content-Type" => "application/json"})
            data = JSON.parse(res.body)
            raw_sponsors = data.dig("data", "viewer", "sponsors", "nodes")
            sponsors = []
            if raw_sponsors
              raw_sponsors.each do |sponsor|
                  sponsors.push(sponsor["login"])
              end
            end
            site.config["sponsors"] = sponsors
            puts sponsors
        end
    end
end