# Copyright 2023 HCL America
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

write-host "======== Step: Exporting scan results to a Sarif File ========"
# Creating script to get ozasmt and export to sarif format
write-output "login_file $env:aseHostname `"$env:aseToken`" -acceptssl" > scriptsarif.scan
write-output "export sarif srcresult.sarif `"$env:aseAppName-$env:BuildNumber.ozasmt`"" >> scriptsarif.scan
write-output "exit" >> scriptsarif.scan  

# Executing the script
AppScanSrcCli scr scriptsarif.scan
