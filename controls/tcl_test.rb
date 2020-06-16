title 'Tests to confirm tcl works as expected'

plan_name = input('plan_name', value: 'tcl')
plan_ident = "#{ENV['HAB_ORIGIN']}/#{plan_name}"
hab_path = input('hab_path', value: 'hab')

control 'core-plans-tcl' do
  impact 1.0
  title 'Ensure tcl works'
  desc '
  To test TCL we borrow a nice one-liner from here: https://wiki.tcl-lang.org/page/One+Liners

    $ echo "puts [string map {a { P} b { a} c { c} d { T} e ck f cl g ha h od i th j {l } k no l {g } m in n Ju o st p er} nobkipapjgepchmlmdf]" | tclsh
    Just another Perl hacker coding in Tcl
  '
  tcl_pkg_ident = command("#{hab_path} pkg path #{plan_ident}")
  describe tcl_pkg_ident do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
  end
  tcl_pkg_ident = tcl_pkg_ident.stdout.strip

  describe command("echo \"puts [string map {a { P} b { a} c { c} d { T} e ck f cl g ha h od i th j {l } k no l {g } m in n Ju o st p er} nobkipapjgepchmlmdf]\" | #{tcl_pkg_ident}/bin/tclsh") do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
    its('stdout') { should match /Just another Perl hacker coding in Tcl/ }
    its('stderr') { should be_empty }
  end
end
