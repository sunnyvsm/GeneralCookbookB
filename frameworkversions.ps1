Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -recurse |
Get-ItemProperty -name Version,Release -EA 0 |
Where { $_.PSChildName -match '^(?!S)\p{L}'} |
Select PSChildName, Version, Release, @{
  name="Product"
  expression={
      switch($_.Release) {
        378389 { [Version]"4.5" }
        378675 { [Version]"4.5.1" }
        378758 { [Version]"4.5.1" }
        379893 { [Version]"4.5.2" }
        393295 { [Version]"4.6" }
        393297 { [Version]"4.6" }
        394254 { [Version]"4.6.1" }
        394271 { [Version]"4.6.1" }
      }
    }
}