module HammerCLIKatello
  module RepositoryScopedToProduct
    def validate_repo_name_requires_product_options(name_option = :option_name)
      validate_options do
        any(:option_product_name, :option_product_id).required if option(name_option).exist?
      end
    end
  end
end
