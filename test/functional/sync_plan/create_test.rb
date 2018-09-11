require_relative '../test_helper'

describe "create sync plan" do
  let(:org_id) { 1 }
  let(:name) { "sync_plan1" }
  let(:hourly) { "hourly" }
  let(:custom) { "custom cron" }
  let(:cron) { "10 * * * *" }
  let(:date) { "2018-09-08T00:00:00+00:00" }

  it 'with organization ID,name,interval,date and enabled' do
    api_expects(:sync_plans, :create, 'create a sync plan').
      with_params('organization_id' => org_id,
                  'name' => name,
                  'interval' => hourly,
                  'sync_date' => date,
                  'enabled' => true)
    command = %W(sync-plan create --organization-id #{org_id} --name #{name}
                 --interval #{hourly} --enabled 1 --sync-date #{date})
    assert_equal(0, run_cmd(command).exit_code)
  end

  it 'with custom cron' do
    api_expects(:sync_plans, :create, 'create a sync plan').
      with_params('organization_id' => org_id,
                  'name' => name,
                  'interval' => custom,
                  'cron_expression' => cron,
                  'sync_date' => date,
                  'enabled' => true)
    # end
    command = %W(sync-plan create --organization-id #{org_id} --name #{name} --interval #{custom}
                 --cron-expression #{cron} --enabled 1 --sync-date #{date})
    assert_equal(0, run_cmd(command).exit_code)
  end

  it 'fails without organization-id' do
    command = %w(sync-plan create --name #{name}
                 --interval #{hourly} --enabled 1 --sync-date #{date})
    refute_equal(0, run_cmd(command).exit_code)
  end

  it 'fails without name' do
    command = %w(sync-plan create --organization-id #{org_id}
                 --interval #{hourly} --enabled 1 --sync-date #{date})
    refute_equal(0, run_cmd(command).err)
  end

  it 'fails without interval' do
    command = %w(sync-plan create --organization-id #{org_id} --name #{name}
                 --enabled 1 --sync-date #{date})
    refute_equal(0, run_cmd(command).exit_code)
  end

  it 'fails without enabled' do
    command = %w(sync-plan create --organization-id #{org_id} --name #{name}
                 --interval #{hourly} --sync-date #{date})
    refute_equal(0, run_cmd(command).exit_code)
  end
end
