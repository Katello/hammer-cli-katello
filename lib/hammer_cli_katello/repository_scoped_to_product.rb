module HammerCLIKatello
  module RepositoryScopedToProduct
    def self.included(base)
      base.validate_options do
        any(:option_product_name, :option_product_id).required if option(:option_name).exist?
      end
    end
  end
end
