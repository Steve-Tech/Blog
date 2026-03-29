# frozen_string_literal: true
 
# Modified from https://github.com/jekyll/jekyll-gist/blob/971e9e65a3ba8737a9eb0dca9199b1d4ed1eb57b/lib/jekyll-gist/gist_tag.rb

require "cgi"
require "net/http"
require "json"

Net::OpenTimeout = Class.new(RuntimeError) unless Net.const_defined?(:OpenTimeout)
Net::ReadTimeout = Class.new(RuntimeError) unless Net.const_defined?(:ReadTimeout)

module Jekyll
  module Gist
    class GistTag < Liquid::Tag
      def render(context)
        @encoding = context.registers[:site].config["encoding"] || "utf-8"
        @settings = context.registers[:site].config["gist"]
        if (tag_contents = determine_arguments(@markup.strip))
          gist_id  = tag_contents[0]
          filename = tag_contents[1]
          gist_id  = context[gist_id]  if context.key?(gist_id)
          filename = context[filename] if context.key?(filename)

          gist_inline_tag(gist_id, filename)
        else
          raise ArgumentError, <<~ERROR
            Syntax error in tag 'gist' while parsing the following markup:

              '{% #{raw.strip} %}'

            Valid syntax:
              {% gist user/1234567 %}
              {% gist user/1234567 foo.js %}
              {% gist 28949e1d5ee2273f9fd3 %}
              {% gist 28949e1d5ee2273f9fd3 best.md %}

          ERROR
        end
      end

      private

      def determine_arguments(input)
        matched = input.match(%r!\A([\S]+|.*(?=\/).+)\s?(\S*)\Z!)
        [matched[1].strip, matched[2].strip] if matched && matched.length >= 3
      end

      def gist_script_tag(gist_id, filename = nil)
        url = "https://gist.github.com/#{gist_id}.js"
        url = "#{url}?file=#{filename}" unless filename.to_s.empty?

        "<script src=\"#{url}\"> </script>"
      end

      def gist_inline_tag(gist_id, filename = nil)
        code = fetch_raw_code(gist_id, filename)
        if code
          code = code.force_encoding(@encoding)
          html = String.new

          code.split("\n").each do |line|
            payload = line.delete_prefix("document.write('").delete_suffix("')")
            if payload.include?("\\\"")
              payload = payload.gsub("\\`", "`").gsub("\\$", "$")
              payload = JSON.parse(%("#{payload}"))
            end
            html << payload.gsub(/<span class=([^"]+?)>/, "<span class=\"\\1\">")
          end

          html
        else
          Jekyll.logger.warn "Warning:", "The inline tag for your gist #{gist_id}"
          Jekyll.logger.warn "", "could not be generated. This will affect users who do"
          Jekyll.logger.warn "", "not have JavaScript enabled in their browsers."
          gist_script_tag(gist_id, filename)
        end
      end

      def fetch_raw_code(gist_id, filename = nil)
        url = "https://gist.github.com/#{gist_id}.js"
        url = "#{url}?file=#{filename}" unless filename.to_s.empty?
        uri = URI(url)

        Net::HTTP.start(uri.host, uri.port,
                        :use_ssl => uri.scheme == "https",
                        :read_timeout => 3, :open_timeout => 3) do |http|
          request = Net::HTTP::Get.new uri.to_s
          response = http.request(request)
          response.body
        end
      rescue SocketError, Net::HTTPError, Net::OpenTimeout, Net::ReadTimeout, TimeoutError
        nil
      end
    end
  end
end

Liquid::Template.register_tag("gist", Jekyll::Gist::GistTag)
