control 'timezone' do
    impact 1.0
    title 'Check timezone is set to Eastern'
    describe command('timedatectl') do
        its('stdout') { should match /Time zone: America\/New_York/ }
    end
end
  
control 'os-version' do
    impact 1.0
    title 'OS should be Ubuntu 22.04 LTS or newer'
  
    describe os.name do
      it { should eq 'ubuntu' }
    end
  
    describe os.release.to_f do
      it { should be >= 22.04 }
    end
end
  
control 'package-updates' do
    impact 1.0
    title 'System packages should be fully updated'
  
    describe command('apt-get update && apt-get -s dist-upgrade') do
        its('stdout') { should_not match /^Inst / }
        its('exit_status') { should eq 0 }
    end
end
  