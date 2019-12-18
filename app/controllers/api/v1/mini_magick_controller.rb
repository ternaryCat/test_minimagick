module Api
  module V1
    class MiniMagickController < ApplicationController
      skip_before_action :verify_authenticity_token

      def process_image
        unless conversions
          return render json: { message: t('errors.missing_conversions') }, status: :unprocessable_entity
        end

        conversions.each do |conversion|
          next unless image.respond_to?(conversion[:method_name]&.to_sym)

          image.send(conversion[:method_name].to_sym, *conversion[:parameters])
        end
        send_file image.path
      rescue TypeError
        render json: { message: t('errors.invalid_image') }, status: :unprocessable_entity
      rescue ActionController::MissingFile, MiniMagick::Error
        render json: { message: t('errors.missing_conversions') }, status: :unprocessable_entity
      end

      private

      def image
        @image ||= MiniMagick::Image.open(File.open(params[:image]))
      end

      def conversions
        params[:conversions]
      end
    end
  end
end
