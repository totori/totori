# Totori - User Acceptance Testing Workbench
# http://totori.org/ - MIT License

Name "Totori workbench"

RequestExecutionLevel admin

# General Symbol Definitions
!define REGKEY "SOFTWARE\$(^Name)"
!define PRODUCT_NAME "Totori workbench"
!define VERSION 0.0.6
!define COMPANY Totori
!define URL http://totori.org/
!define DESCRIPTION "Totori - User Acceptance Testing Workbench"
!define OUT_FILE Totori.workbench-${VERSION}.exe
!define INSTALL_DIR $PROGRAMFILES\eclipse
!define TOTORI_ECLIPSE_PLUGIN org.totori_0.0.5.v201002142344.jar
!define RUBY_DIR "C:\Ruby"

# Included files
!include Sections.nsh
!include Library.nsh

# Reserved Files
ReserveFile "${NSISDIR}\Plugins\StartMenu.dll"

# Variables
Var StartMenuGroup

# Installer pages
Page components
Page directory
Page custom StartMenuGroupSelect "" ": $(StartMenuPageTitle)"
Page instfiles

# Installer languages
LoadLanguageFile "${NSISDIR}\Contrib\Language files\English.nlf"

# Installer attributes
OutFile ${OUT_FILE}
InstallDir ${INSTALL_DIR}
CRCCheck on
XPStyle on
Icon totori.ico
ShowInstDetails hide
AutoCloseWindow false
VIProductVersion ${VERSION}.0
VIAddVersionKey /LANG=${LANG_ENGLISH} ProductName "${PRODUCT_NAME}"
VIAddVersionKey /LANG=${LANG_ENGLISH} ProductVersion "${VERSION}"
VIAddVersionKey /LANG=${LANG_ENGLISH} CompanyName "${COMPANY}"
VIAddVersionKey /LANG=${LANG_ENGLISH} CompanyWebsite "${URL}"
VIAddVersionKey /LANG=${LANG_ENGLISH} FileVersion "${VERSION}"
VIAddVersionKey /LANG=${LANG_ENGLISH} FileDescription "${DESCRIPTION}"
VIAddVersionKey /LANG=${LANG_ENGLISH} LegalCopyright "MIT License"
InstallDirRegKey HKLM "${REGKEY}" Path
UninstallIcon uninstall.ico
ShowUninstDetails show

# Installer sections
!macro CREATE_SMGROUP_SHORTCUT NAME PATH
    Push "${NAME}"
    Push "${PATH}"
    Call CreateSMGroupShortcut
!macroend

Section !Totori SEC0000
    DetailPrint "--------------------------------------------------------------------------------"
    DetailPrint "Installing Totori workbench..."
    SetOutPath $INSTDIR\plugins
    SetOverwrite off
    File thirdparties\org.jupeter.yaml_editor_1.0.2.jar
    File ${TOTORI_ECLIPSE_PLUGIN}
    !insertmacro CREATE_SMGROUP_SHORTCUT "Totori workbench" $INSTDIR
    SetOutPath $DESKTOP
    CreateShortcut "$DESKTOP\Totori workbench.lnk" $INSTDIR
    WriteRegStr HKEY_LOCAL_MACHINE Software\Totori\Workbench Version ${VERSION}
    WriteRegStr HKEY_LOCAL_MACHINE Software\Microsoft\Windows\CurrentVersion\Uninstall\TotoriWorkbench UninstallString "Totori workbench (uninstall)"
    WriteRegStr HKEY_LOCAL_MACHINE Software\Microsoft\Windows\CurrentVersion\Uninstall\TotoriWorkbench UninstallString $INSTDIR\Uninstall.exe
    WriteRegStr HKLM "${REGKEY}\Components" Totori 1
    DetailPrint "success"
SectionEnd

SectionGroup Ruby SECGRP0000
    Section "Ruby 1.8.6" SEC0001
        DetailPrint "--------------------------------------------------------------------------------"
        DetailPrint "Installing Ruby..."
        SetOutPath $TEMP
        SetOverwrite off
        File thirdparties\rubyinstaller-1.8.6-p383-rc1.exe
        SetOutPath ${RUBY_DIR}
        SetOverwrite off
        nsExec::Exec '"$TEMP\rubyinstaller-1.8.6-p383-rc1.exe" /silent /dir=${RUBY_DIR}'
        
        # Adding the Ruby interpreter binaries directory into
        # the system environement PATH variable
        DetailPrint "--------------------------------------------------------------------------------"
        DetailPrint "Setting up the PATH environment variable..."
        Push "PATH"
        Push "P"
        Push "HKCU"
        Push "${RUBY_DIR}\bin"
        Call EnvVarUpdate
        DetailPrint "success"
        #${EnvVarUpdate} $0 "PATH" "P" "HKCU" "${RUBY_DIR}\bin"
        
        #WriteRegStr HKEY_CURRENT_USER PATH "" ${RUBY_DIR}\bin
        WriteRegStr HKLM "${REGKEY}\Components" "Ruby 1.8.6" 1
        DetailPrint "success"
    SectionEnd

    Section "Development kit" SEC0002
        DetailPrint "--------------------------------------------------------------------------------"
        DetailPrint "Installing Windows Development kit..."
        SetOutPath $TEMP
        SetOverwrite off
        File thirdparties\devkit-3.4.5r3-20091110.7z
        SetOutPath ${RUBY_DIR}
        Nsis7z::ExtractWithDetails "$TEMP\devkit-3.4.5r3-20091110.7z" "Installing Windows Development kit %s..."
        WriteRegStr HKLM "${REGKEY}\Components" "Development kit" 1
        DetailPrint "success"
    SectionEnd

    SectionGroup "Ruby gems" SECGRP0001
        Section "Ruby gems" SEC0003
            DetailPrint "--------------------------------------------------------------------------------"
            DetailPrint "Installing Ruby gems..."
            SetOutPath $TEMP
            SetOverwrite on
            File thirdparties\gems\activesupport-2.3.5.gem
            File thirdparties\gems\builder-2.1.2.gem
            File thirdparties\gems\chromewatir-1.5.1.gem
            File thirdparties\gems\commonwatir-1.6.5.gem
            File thirdparties\gems\configuration-1.1.0.gem
            File thirdparties\gems\cucumber-0.4.4.gem
            File thirdparties\gems\diff-lcs-1.1.2.gem
            File thirdparties\gems\firewatir-1.6.5.gem
            File thirdparties\gems\gemcutter-0.3.0.gem
            File thirdparties\gems\hoe-2.3.3.gem
            File thirdparties\gems\json_pure-1.2.0.gem
            File thirdparties\gems\nokogiri-1.4.0-x86-mingw32.gem
            File thirdparties\gems\polyglot-0.2.9.gem
            File thirdparties\gems\rake-0.8.7.gem
            File thirdparties\gems\rspec-1.2.9.gem
            File thirdparties\gems\rubyforge-2.0.3.gem
            File thirdparties\gems\s4t-utils-1.0.4.gem
            File thirdparties\gems\safariwatir-0.3.7.gem
            File thirdparties\gems\syntax-1.0.0.gem
            File thirdparties\gems\term-ansicolor-1.0.4.gem
            File thirdparties\gems\treetop-1.4.2.gem
            File thirdparties\gems\user-choices-1.1.6.gem
            File thirdparties\gems\watir-1.6.5.gem
            File thirdparties\gems\win32-api-1.4.5.gem
            File thirdparties\gems\win32console-1.2.0-x86-mingw32.gem
            File thirdparties\gems\win32-process-0.6.1.gem
            File thirdparties\gems\windows-api-0.4.0.gem
            File thirdparties\gems\windows-pr-1.0.8.gem
            File thirdparties\gems\xml-simple-1.0.12.gem
            DetailPrint "Installing Ruby gems..."
            nsExec::Exec '"${RUBY_DIR}\bin\gem.bat" install -q -l --no-rdoc --no-ri watir cucumber win32console rspec syntax'
            WriteRegStr HKLM "${REGKEY}\Components" "Ruby gems" 1
            DetailPrint "success"
        SectionEnd
    SectionGroupEnd
SectionGroupEnd

SectionGroup Watir SECGRP0002
    Section -AutoItX3 SEC0004
        DetailPrint "--------------------------------------------------------------------------------"
        DetailPrint "Registering AutoItX3 service..."
        SetOutPath $TEMP
        # Installing library ..\totori\workbench\assets\ext\watir\AutoItX3.dll
        !define LIBRARY_IGNORE_VERSION
        !insertmacro InstallLib REGDLL NOTSHARED NOREBOOT_NOTPROTECTED thirdparties\AutoItX3.dll $TEMP\AutoItX3.dll $TEMP
        !undef LIBRARY_IGNORE_VERSION

        WriteRegStr HKLM "${REGKEY}\Components" AutoItX3 1
        DetailPrint "success"
    SectionEnd

    SectionGroup FireWatir SECGRP0003
        Section /o "Firefox 3.6" SEC0005
            DetailPrint "--------------------------------------------------------------------------------"
            DetailPrint "Installing the FireWatir plugin for Firefox 3.6..."
            SetOutPath $TEMP
            SetOverwrite on
            File thirdparties\firefox\jssh-3.6-WINNT.xpi
            nsExec::Exec 'firefox -install-global-extension $TEMP\jssh-3.6-WINNT.xpi'
            WriteRegStr HKLM "${REGKEY}\Components" "Firefox 3.6" 1
            DetailPrint "success"
        SectionEnd

        Section /o "Firefox 3.5" SEC0006
            DetailPrint "--------------------------------------------------------------------------------"
            DetailPrint "Installing the FireWatir plugin for Firefox 3.5..."
            SetOutPath $TEMP
            SetOverwrite on
            File thirdparties\firefox\jssh-3.5.x-WINNT.xpi
            nsExec::Exec 'firefox -install-global-extension $TEMP\jssh-3.5.x-WINNT.xpi'
            File "thirdparties\Microsoft Visual C++ 2008 SP1 Redistributable Package (x86).exe"
            nsExec::Exec '"$TEMP\Microsoft Visual C++ 2008 SP1 Redistributable Package (x86).exe" /Q'
            WriteRegStr HKLM "${REGKEY}\Components" "Firefox 3.5" 1
            DetailPrint "success"
        SectionEnd

        Section /o "Firefox 3.0" SEC0007
            DetailPrint "--------------------------------------------------------------------------------"
            DetailPrint "Installing the FireWatir plugin for Firefox 3.0..."
            SetOutPath $TEMP
            SetOverwrite on
            File thirdparties\firefox\jssh-20080708-WINNT.xpi
            nsExec::Exec 'firefox -install-global-extension $TEMP\jssh-20080708-WINNT.xpi'
            File "thirdparties\Microsoft Visual C++ 2005 SP1 Redistributable Package (x86).exe"
            nsExec::Exec '"$TEMP\Microsoft Visual C++ 2005 SP1 Redistributable Package (x86).exe" /Q'
            WriteRegStr HKLM "${REGKEY}\Components" "Firefox 3.0" 1
            DetailPrint "success"
        SectionEnd

        Section /o "Firefox 2.0" SEC0008
            DetailPrint "--------------------------------------------------------------------------------"
            DetailPrint "Installing the FireWatir plugin for Firefox 2.0..."
            SetOutPath $TEMP
            SetOverwrite on
            File thirdparties\firefox\jssh-WINNT-2.x.xpi
            nsExec::Exec 'firefox -install-global-extension $TEMP\jssh-WINNT-2.x.xpi'
            WriteRegStr HKLM "${REGKEY}\Components" "Firefox 2.0" 1
            DetailPrint "success"
        SectionEnd
    SectionGroupEnd
SectionGroupEnd

Section -post SEC0009
    DetailPrint "--------------------------------------------------------------------------------"
    DetailPrint "Creating shortcuts and setting the registry up..."
    WriteRegStr HKLM "${REGKEY}" Path $INSTDIR
    WriteRegStr HKLM "${REGKEY}" StartMenuGroup $StartMenuGroup
    SetOutPath $INSTDIR
    WriteUninstaller $INSTDIR\uninstall.exe
    !insertmacro CREATE_SMGROUP_SHORTCUT $(^UninstallLink) $INSTDIR\uninstall.exe
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayName "$(^Name)"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayVersion "${VERSION}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" Publisher "${COMPANY}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" URLInfoAbout "${URL}"
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayIcon $INSTDIR\uninstall.exe
    WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" UninstallString $INSTDIR\uninstall.exe
    WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoModify 1
    WriteRegDWORD HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoRepair 1
    DetailPrint "success"
SectionEnd

# Macro for selecting uninstaller sections
!macro SELECT_UNSECTION SECTION_NAME UNSECTION_ID
    Push $R0
    ReadRegStr $R0 HKLM "${REGKEY}\Components" "${SECTION_NAME}"
    StrCmp $R0 1 0 next${UNSECTION_ID}
    !insertmacro SelectSection "${UNSECTION_ID}"
    GoTo done${UNSECTION_ID}
next${UNSECTION_ID}:
    !insertmacro UnselectSection "${UNSECTION_ID}"
done${UNSECTION_ID}:
    Pop $R0
!macroend

# Uninstaller sections
!macro DELETE_SMGROUP_SHORTCUT NAME
    Push "${NAME}"
    Call un.DeleteSMGroupShortcut
!macroend

Section /o "-un.Firefox 2.0" UNSEC0008
    Delete /REBOOTOK $TEMP\jssh-WINNT-2.x.xpi
    DeleteRegValue HKLM "${REGKEY}\Components" "Firefox 2.0"
SectionEnd

Section /o "-un.Firefox 3.0" UNSEC0007
    Delete /REBOOTOK "$TEMP\Microsoft Visual C++ 2005 SP1 Redistributable Package (x86).exe"
    Delete /REBOOTOK $TEMP\jssh-20080708-WINNT.xpi
    DeleteRegValue HKLM "${REGKEY}\Components" "Firefox 3.0"
SectionEnd

Section /o "-un.Firefox 3.5" UNSEC0006
    Delete /REBOOTOK "$TEMP\Microsoft Visual C++ 2008 SP1 Redistributable Package (x86).exe"
    Delete /REBOOTOK $TEMP\jssh-3.5.x-WINNT.xpi
    DeleteRegValue HKLM "${REGKEY}\Components" "Firefox 3.5"
SectionEnd

Section /o "-un.Firefox 3.6" UNSEC0005
    Delete /REBOOTOK $TEMP\jssh-3.6-WINNT.xpi
    DeleteRegValue HKLM "${REGKEY}\Components" "Firefox 3.6"
SectionEnd

Section /o -un.AutoItX3 UNSEC0004
    # Uninstalling library $INSTDIR\AutoItX3.dll
    !insertmacro UnInstallLib REGDLL NOTSHARED NOREBOOT_NOTPROTECTED $INSTDIR\AutoItX3.dll

    DeleteRegValue HKLM "${REGKEY}\Components" AutoItX3
SectionEnd

Section /o "-un.Ruby gems" UNSEC0003
    Delete /REBOOTOK $TEMP\xml-simple-1.0.12.gem
    Delete /REBOOTOK $TEMP\windows-pr-1.0.8.gem
    Delete /REBOOTOK $TEMP\windows-api-0.4.0.gem
    Delete /REBOOTOK $TEMP\win32-process-0.6.1.gem
    Delete /REBOOTOK $TEMP\win32console-1.2.0-x86-mingw32.gem
    Delete /REBOOTOK $TEMP\win32-api-1.4.5.gem
    Delete /REBOOTOK $TEMP\watir-1.6.5.gem
    Delete /REBOOTOK $TEMP\user-choices-1.1.6.gem
    Delete /REBOOTOK $TEMP\treetop-1.4.2.gem
    Delete /REBOOTOK $TEMP\term-ansicolor-1.0.4.gem
    Delete /REBOOTOK $TEMP\syntax-1.0.0.gem
    Delete /REBOOTOK $TEMP\safariwatir-0.3.7.gem
    Delete /REBOOTOK $TEMP\s4t-utils-1.0.4.gem
    Delete /REBOOTOK $TEMP\rubyforge-2.0.3.gem
    Delete /REBOOTOK $TEMP\rspec-1.2.9.gem
    Delete /REBOOTOK $TEMP\rake-0.8.7.gem
    Delete /REBOOTOK $TEMP\polyglot-0.2.9.gem
    Delete /REBOOTOK $TEMP\nokogiri-1.4.0-x86-mingw32.gem
    Delete /REBOOTOK $TEMP\json_pure-1.2.0.gem
    Delete /REBOOTOK $TEMP\hoe-2.3.3.gem
    Delete /REBOOTOK $TEMP\gemcutter-0.3.0.gem
    Delete /REBOOTOK $TEMP\firewatir-1.6.5.gem
    Delete /REBOOTOK $TEMP\diff-lcs-1.1.2.gem
    Delete /REBOOTOK $TEMP\cucumber-0.4.4.gem
    Delete /REBOOTOK $TEMP\configuration-1.1.0.gem
    Delete /REBOOTOK $TEMP\commonwatir-1.6.5.gem
    Delete /REBOOTOK $TEMP\chromewatir-1.5.1.gem
    Delete /REBOOTOK $TEMP\builder-2.1.2.gem
    Delete /REBOOTOK $TEMP\activesupport-2.3.5.gem
    DeleteRegValue HKLM "${REGKEY}\Components" "Ruby gems"
SectionEnd

Section /o "-un.Development kit" UNSEC0002
    Delete /REBOOTOK $TEMP\devkit-3.4.5r3-20091110.7z
    DeleteRegValue HKLM "${REGKEY}\Components" "Development kit"
SectionEnd

Section /o "-un.Ruby 1.8.6" UNSEC0001
    #DeleteRegValue HKEY_CURRENT_USER PATH ""
    #${un.EnvVarUpdate} $0 "PATH" "R" "HKCU" "${RUBY_DIR}\bin"
  Push "PATH"
  Push "R"
  Push "HKCU"
  Push "${RUBY_DIR}\bin"
  Call un.EnvVarUpdate
    Delete /REBOOTOK ${RUBY_DIR}\rubyinstaller-1.8.6-p383-rc1.exe
    DeleteRegValue HKLM "${REGKEY}\Components" "Ruby 1.8.6"
SectionEnd

Section /o -un.Totori UNSEC0000
    DeleteRegValue HKEY_LOCAL_MACHINE Software\Microsoft\Windows\CurrentVersion\Uninstall\TotoriWorkbench UninstallString
    DeleteRegValue HKEY_LOCAL_MACHINE Software\Microsoft\Windows\CurrentVersion\Uninstall\TotoriWorkbench UninstallString
    DeleteRegValue HKEY_LOCAL_MACHINE Software\Totori\Workbench Version
    Delete /REBOOTOK "$DESKTOP\Totori workbench.lnk"
    !insertmacro DELETE_SMGROUP_SHORTCUT "Totori workbench"
    Delete /REBOOTOK $INSTDIR\plugins\org.jupeter.yaml_editor_1.0.2.jar
    Delete /REBOOTOK $INSTDIR\plugins\${TOTORI_ECLIPSE_PLUGIN}
    DeleteRegValue HKLM "${REGKEY}\Components" Totori
SectionEnd

Section -un.post UNSEC0009
    DeleteRegKey HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)"
    !insertmacro DELETE_SMGROUP_SHORTCUT $(^UninstallLink)
    Delete /REBOOTOK $INSTDIR\uninstall.exe
    DeleteRegValue HKLM "${REGKEY}" StartMenuGroup
    DeleteRegValue HKLM "${REGKEY}" Path
    DeleteRegKey /IfEmpty HKLM "${REGKEY}\Components"
    DeleteRegKey /IfEmpty HKLM "${REGKEY}"
    RmDir /REBOOTOK $SMPROGRAMS\$StartMenuGroup
    RmDir /REBOOTOK $INSTDIR
    Push $R0
    StrCpy $R0 $StartMenuGroup 1
    StrCmp $R0 ">" no_smgroup
no_smgroup:
    Pop $R0
SectionEnd

# Installer functions
Function StartMenuGroupSelect
    Push $R1
    StartMenu::Select /checknoshortcuts "$(DisableStartMenuShortcutsText)" /autoadd /text "$(StartMenuPageText)" /lastused $StartMenuGroup Totori\Workbench
    Pop $R1
    StrCmp $R1 success success
    StrCmp $R1 cancel done
    MessageBox MB_OK $R1
    Goto done
success:
    Pop $StartMenuGroup
done:
    Pop $R1
FunctionEnd

Function .onInit
    InitPluginsDir
FunctionEnd

Function CreateSMGroupShortcut
    Exch $R0 ;PATH
    Exch
    Exch $R1 ;NAME
    Push $R2
    StrCpy $R2 $StartMenuGroup 1
    StrCmp $R2 ">" no_smgroup
    SetOutPath $SMPROGRAMS\$StartMenuGroup
    CreateShortcut "$SMPROGRAMS\$StartMenuGroup\$R1.lnk" $R0
no_smgroup:
    Pop $R2
    Pop $R1
    Pop $R0
FunctionEnd

# Uninstaller functions
Function un.onInit
    ReadRegStr $INSTDIR HKLM "${REGKEY}" Path
    ReadRegStr $StartMenuGroup HKLM "${REGKEY}" StartMenuGroup
    !insertmacro SELECT_UNSECTION Totori ${UNSEC0000}
    !insertmacro SELECT_UNSECTION "Ruby 1.8.6" ${UNSEC0001}
    !insertmacro SELECT_UNSECTION "Development kit" ${UNSEC0002}
    !insertmacro SELECT_UNSECTION "Ruby gems" ${UNSEC0003}
    !insertmacro SELECT_UNSECTION AutoItX3 ${UNSEC0004}
    !insertmacro SELECT_UNSECTION "Firefox 3.6" ${UNSEC0005}
    !insertmacro SELECT_UNSECTION "Firefox 3.5" ${UNSEC0006}
    !insertmacro SELECT_UNSECTION "Firefox 3.0" ${UNSEC0007}
    !insertmacro SELECT_UNSECTION "Firefox 2.0" ${UNSEC0008}
FunctionEnd

Function un.DeleteSMGroupShortcut
    Exch $R1 ;NAME
    Push $R2
    StrCpy $R2 $StartMenuGroup 1
    StrCmp $R2 ">" no_smgroup
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\$R1.lnk"
no_smgroup:
    Pop $R2
    Pop $R1
FunctionEnd

# Installer Language Strings
# TODO Update the Language Strings with the appropriate translations.

LangString StartMenuPageTitle ${LANG_ENGLISH} "Start Menu Folder"

LangString StartMenuPageText ${LANG_ENGLISH} "Select the Start Menu folder in which to create the program's shortcuts:"

LangString DisableStartMenuShortcutsText ${LANG_ENGLISH} "Do not create shortcuts"

LangString ^UninstallLink ${LANG_ENGLISH} "Uninstall $(^Name)"






/**
 *  EnvVarUpdate.nsh
 *    : Environmental Variables: append, prepend, and remove entries
 *
 *     WARNING: If you use StrFunc.nsh header then include it before this file
 *              with all required definitions. This is to avoid conflicts
 *
 *  Usage:
 *    ${EnvVarUpdate} "ResultVar" "EnvVarName" "Action" "RegLoc" "PathString"
 *
 *  Credits:
 *  Version 1.0 
 *  * Cal Turney (turnec2)
 *  * Amir Szekely (KiCHiK) and e-circ for developing the forerunners of this
 *    function: AddToPath, un.RemoveFromPath, AddToEnvVar, un.RemoveFromEnvVar,
 *    WriteEnvStr, and un.DeleteEnvStr
 *  * Diego Pedroso (deguix) for StrTok
 *  * Kevin English (kenglish_hi) for StrContains
 *  * Hendri Adriaens (Smile2Me), Diego Pedroso (deguix), and Dan Fuhry  
 *    (dandaman32) for StrReplace
 *
 *  Version 1.1 (compatibility with StrFunc.nsh)
 *  * techtonik
 *
 *  http://nsis.sourceforge.net/Environmental_Variables:_append%2C_prepend%2C_and_remove_entries
 *
 */
 
 
!ifndef ENVVARUPDATE_FUNCTION
!define ENVVARUPDATE_FUNCTION
!verbose push
!verbose 3
!include "LogicLib.nsh"
!include "WinMessages.NSH"
!include "StrFunc.nsh"
 
; ---- Fix for conflict if StrFunc.nsh is already includes in main file -----------------------
!macro _IncludeStrFunction StrFuncName
  !ifndef ${StrFuncName}_INCLUDED
    ${${StrFuncName}}
  !endif
  !ifndef Un${StrFuncName}_INCLUDED
    ${Un${StrFuncName}}
  !endif
  !define un.${StrFuncName} "${Un${StrFuncName}}"
!macroend
 
!insertmacro _IncludeStrFunction StrTok
!insertmacro _IncludeStrFunction StrStr
!insertmacro _IncludeStrFunction StrRep
 
; ---------------------------------- Macro Definitions ----------------------------------------
!macro _EnvVarUpdateConstructor ResultVar EnvVarName Action Regloc PathString
  Push "${EnvVarName}"
  Push "${Action}"
  Push "${RegLoc}"
  Push "${PathString}"
    Call EnvVarUpdate
  Pop "${ResultVar}"
!macroend
!define EnvVarUpdate '!insertmacro "_EnvVarUpdateConstructor"'
 
!macro _unEnvVarUpdateConstructor ResultVar EnvVarName Action Regloc PathString
  Push "${EnvVarName}"
  Push "${Action}"
  Push "${RegLoc}"
  Push "${PathString}"
    Call un.EnvVarUpdate
  Pop "${ResultVar}"
!macroend
!define un.EnvVarUpdate '!insertmacro "_unEnvVarUpdateConstructor"'
; ---------------------------------- Macro Definitions end-------------------------------------
 
;----------------------------------- EnvVarUpdate start----------------------------------------
!define hklm_all_users     'HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"'
!define hkcu_current_user  'HKCU "Environment"'
 
!macro EnvVarUpdate UN
 
Function ${UN}EnvVarUpdate
 
  Push $0
  Exch 4
  Exch $1
  Exch 3
  Exch $2
  Exch 2
  Exch $3
  Exch
  Exch $4
  Push $5
  Push $6
  Push $7
  Push $8
  Push $9
  Push $R0
 
  /* After this point:
  -------------------------
     $0 = ResultVar     (returned)
     $1 = EnvVarName    (input)
     $2 = Action        (input)
     $3 = RegLoc        (input)
     $4 = PathString    (input)
     $5 = Orig EnvVar   (read from registry)
     $6 = Len of $0     (temp)
     $7 = tempstr1      (temp)
     $8 = Entry counter (temp)
     $9 = tempstr2      (temp)
     $R0 = tempChar     (temp)  */
 
  ; Step 1:  Read contents of EnvVarName from RegLoc
  ;
  ; Check for empty EnvVarName
  ${If} $1 == ""
    SetErrors
    DetailPrint "ERROR: EnvVarName is blank"
    Goto EnvVarUpdate_Restore_Vars
  ${EndIf}
 
  ; Check for valid Action
  ${If}    $2 != "A"
  ${AndIf} $2 != "P"
  ${AndIf} $2 != "R"
    SetErrors
    DetailPrint "ERROR: Invalid Action - must be A, P, or R"
    Goto EnvVarUpdate_Restore_Vars
  ${EndIf}
 
  ${If} $3 == HKLM
    ReadRegStr $5 ${hklm_all_users} $1     ; Get EnvVarName from all users into $5
  ${ElseIf} $3 == HKCU
    ReadRegStr $5 ${hkcu_current_user} $1  ; Read EnvVarName from current user into $5
  ${Else}
    SetErrors
    DetailPrint 'ERROR: Action is [$3] but must be "HKLM" or HKCU"'
    Goto EnvVarUpdate_Restore_Vars
  ${EndIf}
 
  ; Check for empty PathString
  ${If} $4 == ""
    SetErrors
    DetailPrint "ERROR: PathString is blank"
    Goto EnvVarUpdate_Restore_Vars
  ${EndIf}
 
  ; Make sure we've got some work to do
  ${If} $5 == ""
  ${AndIf} $2 == "R"
    SetErrors
    DetailPrint "$1 is empty - Nothing to remove"
    Goto EnvVarUpdate_Restore_Vars
  ${EndIf}
 
  ; Step 2: Scrub EnvVar
  ;
  StrCpy $0 $5                             ; Copy the contents to $0
  ; Remove spaces around semicolons (NOTE: spaces before the 1st entry or
  ; after the last one are not removed here but instead in Step 3)
  ${If} $0 != ""                           ; If EnvVar is not empty ...
    ${Do}
      ${${UN}StrStr} $7 $0 " ;"
      ${If} $7 == ""
        ${ExitDo}
      ${EndIf}
      ${${UN}StrRep} $0  $0 " ;" ";"         ; Remove '<space>;'
    ${Loop}
    ${Do}
      ${${UN}StrStr} $7 $0 "; "
      ${If} $7 == ""
        ${ExitDo}
      ${EndIf}
      ${${UN}StrRep} $0  $0 "; " ";"         ; Remove ';<space>'
    ${Loop}
    ${Do}
      ${${UN}StrStr} $7 $0 ";;" 
      ${If} $7 == ""
        ${ExitDo}
      ${EndIf}
      ${${UN}StrRep} $0  $0 ";;" ";"
    ${Loop}
 
    ; Remove a leading or trailing semicolon from EnvVar
    StrCpy  $7  $0 1 0
    ${If} $7 == ";"
      StrCpy $0  $0 "" 1                   ; Change ';<EnvVar>' to '<EnvVar>'
    ${EndIf}
    StrLen $6 $0
    IntOp $6 $6 - 1
    StrCpy $7  $0 1 $6
    ${If} $7 == ";"
     StrCpy $0  $0 $6                      ; Change ';<EnvVar>' to '<EnvVar>'
    ${EndIf}
    ; DetailPrint "Scrubbed $1: [$0]"      ; Uncomment to debug
  ${EndIf}
 
  /* Step 3. Remove all instances of the target path/string (even if "A" or "P")
     $6 = bool flag (1 = found and removed PathString)
     $7 = a string (e.g. path) delimited by semicolon(s)
     $8 = entry counter starting at 0
     $9 = copy of $0
     $R0 = tempChar      */
 
  ${If} $5 != ""                           ; If EnvVar is not empty ...
    StrCpy $9 $0
    StrCpy $0 ""
    StrCpy $8 0
    StrCpy $6 0
 
    ${Do}
      ${${UN}StrTok} $7 $9 ";" $8 "0"      ; $7 = next entry, $8 = entry counter
 
      ${If} $7 == ""                       ; If we've run out of entries,
        ${ExitDo}                          ;    were done
      ${EndIf}                             ;
 
      ; Remove leading and trailing spaces from this entry (critical step for Action=Remove)
      ${Do}
        StrCpy $R0  $7 1
        ${If} $R0 != " "
          ${ExitDo}
        ${EndIf}
        StrCpy $7   $7 "" 1                ;  Remove leading space
      ${Loop}
      ${Do}
        StrCpy $R0  $7 1 -1
        ${If} $R0 != " "
          ${ExitDo}
        ${EndIf}
        StrCpy $7   $7 -1                  ;  Remove trailing space
      ${Loop}
      ${If} $7 == $4                       ; If string matches, remove it by not appending it
        StrCpy $6 1                        ; Set 'found' flag
      ${ElseIf} $7 != $4                   ; If string does NOT match
      ${AndIf}  $0 == ""                   ;    and the 1st string being added to $0,
        StrCpy $0 $7                       ;    copy it to $0 without a prepended semicolon
      ${ElseIf} $7 != $4                   ; If string does NOT match
      ${AndIf}  $0 != ""                   ;    and this is NOT the 1st string to be added to $0,
        StrCpy $0 $0;$7                    ;    append path to $0 with a prepended semicolon
      ${EndIf}                             ;
 
      IntOp $8 $8 + 1                      ; Bump counter
    ${Loop}                                ; Check for duplicates until we run out of paths
  ${EndIf}
 
  ; Step 4:  Perform the requested Action
  ;
  ${If} $2 != "R"                          ; If Append or Prepend
    ${If} $6 == 1                          ; And if we found the target
      DetailPrint "Target is already present in $1. It will be removed and"
    ${EndIf}
    ${If} $0 == ""                         ; If EnvVar is (now) empty
      StrCpy $0 $4                         ;   just copy PathString to EnvVar
      ${If} $6 == 0                        ; If found flag is either 0
      ${OrIf} $6 == ""                     ; or blank (if EnvVarName is empty)
        DetailPrint "$1 was empty and has been updated with the target"
      ${EndIf}
    ${ElseIf} $2 == "A"                    ;  If Append (and EnvVar is not empty),
      StrCpy $0 $0;$4                      ;     append PathString
      ${If} $6 == 1
        DetailPrint "appended to $1"
      ${Else}
        DetailPrint "Target was appended to $1"
      ${EndIf}
    ${Else}                                ;  If Prepend (and EnvVar is not empty),
      StrCpy $0 $4;$0                      ;     prepend PathString
      ${If} $6 == 1
        DetailPrint "prepended to $1"
      ${Else}
        DetailPrint "Target was prepended to $1"
      ${EndIf}
    ${EndIf}
  ${Else}                                  ; If Action = Remove
    ${If} $6 == 1                          ;   and we found the target
      DetailPrint "Target was found and removed from $1"
    ${Else}
      DetailPrint "Target was NOT found in $1 (nothing to remove)"
    ${EndIf}
    ${If} $0 == ""
      DetailPrint "$1 is now empty"
    ${EndIf}
  ${EndIf}
 
  ; Step 5:  Update the registry at RegLoc with the updated EnvVar and announce the change
  ;
  ClearErrors
  ${If} $3  == HKLM
    WriteRegExpandStr ${hklm_all_users} $1 $0     ; Write it in all users section
  ${ElseIf} $3 == HKCU
    WriteRegExpandStr ${hkcu_current_user} $1 $0  ; Write it to current user section
  ${EndIf}
 
  IfErrors 0 +4
    MessageBox MB_OK|MB_ICONEXCLAMATION "Could not write updated $1 to $3"
    DetailPrint "Could not write updated $1 to $3"
    Goto EnvVarUpdate_Restore_Vars
 
  ; "Export" our change
  SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000
 
  EnvVarUpdate_Restore_Vars:
  ;
  ; Restore the user's variables and return ResultVar
  Pop $R0
  Pop $9
  Pop $8
  Pop $7
  Pop $6
  Pop $5
  Pop $4
  Pop $3
  Pop $2
  Pop $1
  Push $0  ; Push my $0 (ResultVar)
  Exch
  Pop $0   ; Restore his $0
 
FunctionEnd
 
!macroend   ; EnvVarUpdate UN
!insertmacro EnvVarUpdate ""
!insertmacro EnvVarUpdate "un."
;----------------------------------- EnvVarUpdate end----------------------------------------
 
!verbose pop
!endif
