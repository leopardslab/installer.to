Describe "Installer script for"
  Describe "hello"
    It "should say hello!"
      When call installers/hello/installer.sh
      The output should eq "Hello!"
    End
  End
End
