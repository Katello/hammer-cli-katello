module ErratumHelpers
  # rubocop:disable MethodLength
  def make_erratum_response(with_packages = true, with_module_streams = true)
    packs = with_packages ? packages : []
    if with_module_streams
      module_streams = [
        {
          "name" => module_stream[:name],
          "stream" => module_stream[:stream],
          "version" => "20180730223407",
          "context" => "deadbeef",
          "arch" => "noarch",
          "id" => 4,
          "packages" => packs
        }
      ]
    else
      module_streams = []
    end
    {
      "id" => 6,
      "pulp_id" => "a4999071-2e2a-4293-9a72-219924032633",
      "title" => "Duck_Kangaroo_Erratum",
      "errata_id" => "RHEA-2012:0059",
      "issued" => "2018-01-27",
      "updated" => "2018-07-20",
      "severity" => "",
      "description" => "Duck_Kangaro_Erratum description",
      "solution" => "",
      "summary" => "",
      "reboot_suggested" => false,
      "uuid" => "a4999071-2e2a-4293-9a72-219924032633",
      "name" => "Duck_Kangaroo_Erratum",
      "type" => "enhancement",
      "cves" => [],
      "bugs" => [],
      "hosts_available_count" => 0,
      "hosts_applicable_count" => 0,
      "packages" => packages,
      "module_streams" => module_streams
    }
  end

  def packages
    ["kangaroo-0.3-1.noarch", "bar"]
  end

  def module_stream
    {name: "MyMOdule", stream: "cool-100"}
  end

  def erratum_id
    "1"
  end

  def host_id
    1
  end

  def verify_module_packages_and_orphan_packages(result)
    result_out = result.out
    # output looks like
    # => "Title:            Duck_Kangaroo_Erratum\n
    # Description:      Duck_Kangaro_Erratum description\n
    # ID:               6
    # \nErrata ID:        RHEA-2012:0059\nReboot Suggested: false\n
    # Updated:          2018-07-20\nIssued:           2018-01-27\nSolution:
    # \nPackages:         kangaroo-0.3-1.noarch
    #\nModule Streams:   \n 1) Name:     kangaroo\n    Stream:   0
    # \n    Packages: kangaroo-0.3-1.noarch\n\n
    module_streams_out = result_out.slice(result_out.index("Module Streams")..-1)
    package_out = result_out.slice(0..result_out.index("Module Streams"))

    assert_includes(module_streams_out, "Name")
    assert_includes(module_streams_out, module_stream[:name])
    assert_includes(module_streams_out, "Stream")
    assert_includes(module_streams_out, module_stream[:stream])
    assert_includes(module_streams_out, packages.first)
    assert_includes(module_streams_out, packages.last)

    assert_includes(package_out, packages.first)
    assert_includes(package_out, packages.last)
  end

  def verify_no_modules_packages_with_orphan_packages(result)
    result_out = result.out
    refute_includes(result_out, "Module Streams")
    assert_includes(result_out, packages.first)
    assert_includes(result_out, packages.last)
  end
end
