require_relative '../test_helper'
require 'hammer_cli_katello/id_name_options_validator'

module HammerCLIKatello
  describe IdNameOptionsValidator do
    before(:each) do
      @cmd = Object.new
      @cmd.extend(IdNameOptionsValidator)
      @cmd.class.send(:define_method, :validate_options) do |&block|
        block.call
      end
    end

    describe '#validate_id_or_name_with_parent' do
      it 'accepts no record name and validates id, name, and parent opts' do
        any_stub = stub(:required => true)
        option_stub = stub(:exist? => true)
        @cmd.stubs(:option).returns(option_stub)

        @cmd.expects(:any).with('option_id', 'option_name').returns(any_stub)
        @cmd.expects(:any).with('option_organization_id',
                                'option_organization_name',
                                'option_organization_label'
                               ).returns(any_stub)

        @cmd.validate_id_or_name_with_parent
      end

      it 'accepts content view as a record name' do
        any_stub = stub(:required => true)
        option_stub = stub(:exist? => true)
        @cmd.stubs(:option).returns(option_stub)

        @cmd.expects(:any).with('option_content_view_id',
                                'option_content_view_name'
                               ).returns(any_stub)
        @cmd.expects(:any).with('option_organization_id',
                                'option_organization_name',
                                'option_organization_label'
                               ).returns(any_stub)

        @cmd.validate_id_or_name_with_parent(:content_view)
      end

      it 'does not validate org options if the name opt is not used' do
        any_stub = stub(:required => true)
        option_stub = stub(:exist? => false) # --name was not supplied
        @cmd.stubs(:option).returns(option_stub)

        @cmd.expects(:any).at_most_once.returns(any_stub)

        @cmd.validate_id_or_name_with_parent
      end

      it 'does not validate name or id if required is false' do
        any_stub = stub(:required => true)
        option_stub = stub(:exist? => true)
        @cmd.stubs(:option).returns(option_stub)

        @cmd.expects(:any).with('option_organization_id',
                                'option_organization_name',
                                'option_organization_label'
                               ).returns(any_stub)

        @cmd.validate_id_or_name_with_parent(required: false)
      end

      it 'accepts a hash of fields for the parent' do
        any_stub = stub(:required => true)
        option_stub = stub(:exist? => true)
        @cmd.stubs(:option).returns(option_stub)

        @cmd.expects(:any).with('option_id', 'option_name').returns(any_stub)
        @cmd.expects(:any).with('option_product_test').returns(any_stub)

        @cmd.validate_id_or_name_with_parent(parent: {:product => ['test']})
      end
    end

    describe '#validate_id_or_name' do
      it 'validates that id or name is required' do
        any_stub = stub(:required => true)
        @cmd.expects(:any).with('option_id', 'option_name').returns(any_stub)
        @cmd.validate_id_or_name
      end

      it 'accepts a custom record name' do
        any_stub = stub(:required => true)
        @cmd.expects(:any).with('option_content_view_id',
                                'option_content_view_name'
                               ).returns(any_stub)
        @cmd.validate_id_or_name(:content_view)
      end
    end
  end
end
