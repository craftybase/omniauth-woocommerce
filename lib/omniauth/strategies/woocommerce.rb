module OmniAuth
  module Strategies
    class WooCommerce
      include OmniAuth::Strategy

      option :name, :woocommerce
      option :site, nil
      option :return_url, nil
      option :user_id, 0
      option :on_failed_registration, nil

      uid         { site }
      info        { { site: site } }
      credentials { { token: identity["consumer_key"], secret: identity["consumer_secret"] } }
      extra       { { provider: 'woocommerce', raw_info: identity } }

      def request_phase
        endpoint = '/wc-auth/v1/authorize'
        params = {
          app_name: app_name,
          scope: scope,
          user_id: user_id,
          return_url: return_url,
          callback_url: callback_url
        }
        query_string = URI.encode_www_form(params)

        redirect("#{site}#{endpoint}?#{query_string}")
      end

      def callback_phase
        return fail!(:invalid_credentials) if not identity
        super
      end

      def identity
        return unless site
        unless @identity
          request.body.rewind if request.body.respond_to?(:rewind)
          @identity = JSON.parse(request.body.read)
          request.body.rewind if request.body.respond_to?(:rewind)
        end
        @identity
      end

      protected

      def callback_url
        query = URI.encode_www_form({ return_url: return_url, site: site, user_id: user_id })
        full_host + callback_path + "?#{query}"
      end

      def site
        url = /(https?:\/\/)?.*\.\w+(\.\w+)*(\/\w+)*(\.\w*)?/.match(options.site).to_s
        validate_site(url)
      end

      def app_name
        options.app_name
      end

      def scope
        options.scope
      end

      def user_id
        options.user_id
      end

      def return_url
        options.return_url
      end

      def uri?(uri)
        uri = URI.parse(uri)
        %W(http https).include?(uri.scheme)
      rescue
        false
      end

      def validate_site(str)
        if str and str != ''
          uri?(str) ? str : "https://#{str}"
        end
      end
    end
  end
end

OmniAuth.config.add_camelization 'woocommerce', 'WooCommerce'
