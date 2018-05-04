# Plugin to add environment variables to the `site` object in Liquid templates

module Jekyll

  class EnvironmentVariablesGenerator < Generator

    def generate(site)
      site.config['domain'] = ENV['DOMAIN'] || 'badsite.io'
      site.config['cross-origin-domain'] = ENV['CROSS_ORIGIN_DOMAIN'] || 'badsite.cross-origin.io'
      site.config['http-domain'] = ENV['HTTP_DOMAIN'] || 'http.' + site.config['domain']
      site.config['serving-path'] = ENV['SERVING_PATH'] || '/var/www/badsite/_site'

      site.config['cert-path'] = site.config['serving-path'] + '/certs/sets/current/gen/chain'
      site.config['dhparam-path'] = site.config['serving-path'] + '/certs/sets/current/gen/dhparam'
    end

  end

end
