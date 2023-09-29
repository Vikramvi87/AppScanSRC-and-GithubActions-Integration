# AppScan Source (SAST) and Github Actions Integration
</br>
It will help to Integrate AppScan Source on Github. It will enable Github to start scan, generate report, publish results to AppScan Source Database and AppScan Enterprise and check for Security Gate.<br>
<br>
Requirements:<br>
1 - AppScan Source in Windows Server.<br>
2 - Add AppScan Source bin folder to Windows PATH Environment Variable.<br>
3 - Install Github Actions for Windows in same Windows Server that has AppScan Source.
3.1 - Add Github Actions as a Service.<br>
3.2 - Change User Service to same User that has access in AppScan Enterprise.<br>
  Source: https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners/about-github-hosted-runners <br>
4 - Create AppScan Enterprise token <install_dir>\bin\ounceautod.exe -u username -p password --persist.<br>
  Source: https://help.hcltechsw.com/appscan/Source/10.3.0/topics/ounce_auto_login.html <br>
5 - Configure AppScan Source to Authenticate  in AppScan Enterprise. <br>
  Source: https://help.hcltechsw.com/appscan/Source/10.3.0/topics/preferences_ase_2.html
6 - In the YAML file:<br>
6.1 - Add AppScan Enterprise (ase) key pair (aseApiKeyId and aseApiKeySecret) and hostname (aseHostname).<br>
6.2 - When compiledArtifactFolder variable is <b>none</b> that means AppScan Source will run SourceCodeOnly scan, if you have a step before the scan where you are creating the compiled files (.war, .jar, .ear, .dll or .exe) you have option to pass the folder where you have the compiled files and then the scan will be in this files. 

```yaml
env:
  aseApiKeyId: xxxxxxxxxxxxxxx
  aseApiKeySecret: xxxxxxxxxxxxxxx
  compiledArtifactFolder: none
  scanConfig: Normal scan
  aseAppName: ${{GITHUB.EVENT.REPOSITORY.NAME}}
  aseHostname: xxxxxxxxxxxxxxx
  aseToken: C:\ProgramData\HCL\AppScanSource\config\ounceautod.token
  sevSecGw: highIssues
  maxIssuesAllowed: 1000
  WorkingDirectory: ${{GITHUB.WORKSPACE}}
  BuildNumber: ${{GITHUB.RUN_NUMBER}}

name: HCL AppScan Source
on:
  workflow_dispatch:
jobs:
  build:
    runs-on: self-hosted
    steps:
      - uses: actions/checkout@v3
      - name: Scan SAST
        shell: pwsh
        run: |
          Invoke-WebRequest -Uri https://raw.githubusercontent.com/jrocia/AppScanSRC-and-GithubActions-Integration/main/scripts/appscanase_create_application_ase.ps1 -OutFile appscanase_create_application_ase.ps1
          .\appscanase_create_application_ase.ps1
          Invoke-WebRequest -Uri https://raw.githubusercontent.com/jrocia/AppScanSRC-and-GithubActions-Integration/main/scripts/appscansrc_create_config_scan_folder.ps1 -OutFile appscansrc_create_config_scan_folder.ps1
          .\appscansrc_create_config_scan_folder.ps1
          Invoke-WebRequest -Uri https://raw.githubusercontent.com/jrocia/AppScanSRC-and-GithubActions-Integration/main/scripts/appscansrc_scan.ps1 -OutFile appscansrc_scan.ps1
          .\appscansrc_scan.ps1
          Invoke-WebRequest -Uri https://raw.githubusercontent.com/jrocia/AppScanSRC-and-GithubActions-Integration/main/scripts/appscansrc_publish_assessment_to_enterprise.ps1 -OutFile appscansrc_publish_assessment_to_enterprise.ps1
          .\appscansrc_publish_assessment_to_enterprise.ps1
          Invoke-WebRequest -Uri https://raw.githubusercontent.com/jrocia/AppScanSRC-and-GithubActions-Integration/main/scripts/appscansrc_check_security_gate.ps1 -OutFile appscansrc_check_security_gate.ps1
          .\appscansrc_check_security_gate.ps1
      - uses: actions/upload-artifact@v3
        with:
          name: Upload report
          path: ${{GITHUB.EVENT.REPOSITORY.NAME}}-${{GITHUB.RUN_NUMBER}}.pdf
```
