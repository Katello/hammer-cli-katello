module ForemanTaskHelpers
  def expect_foreman_task(task_id)
    ex = api_expects(:foreman_tasks, :show, 'Show task')
    ex.returns('id' => task_id, 'state' => 'stopped')
  end
end
