# test commands
describe command('/usr/bin/env java -version') do
  its('stderr') { should match '/*java version "1.8/*' }
  its('exit_status') { should cmp 0 }
end
