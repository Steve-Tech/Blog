require "down"
require 'net/http'

module Jekyll

    Jekyll::Hooks.register :site, :after_init do |site|
        bs_ver = site.config["bootswatch"]["version"].to_s
        bs_name = site.config["bootswatch"]["name"]
        if ENV["JEKYLL_ENV"] != "production"
            bs_api = JSON.parse(Net::HTTP.get_response(URI.parse("https://bootswatch.com/api/" + bs_ver + ".json")).body)
            puts "Downloading Bootswatch " + bs_api["version"] + ": "
        else
            puts "Downloading Bootswatch: "
        end

        bs_url = "https://bootswatch.com/" + bs_ver + "/" + bs_name + "/bootstrap.min.css"
        bs_path = "./css/bootstrap-" + bs_name + ".min.css"
        puts bs_url
        Down.download(bs_url, destination: bs_path)

        puts "Downloaded Bootswatch to " + bs_path
    end

end