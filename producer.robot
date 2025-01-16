*** Settings ***
Documentation       Inhuman Insurance, Inc. Artificial Intelligence System robot.
...                 Produces traffic data work items.

Library    RPA.HTTP
Library    RPA.JSON
Library    RPA.Excel.Application
Library    RPA.FileSystem
Library    RPA.Tables
*** Variables ***
${OUTPUT_DIR}   C:\\Users\\Ponraj\\OneDrive - Yitro Business Consultants India Private Limited\\Pictures\\Saved Pictures
${url}          https://github.com/robocorp/inhuman-insurance-inc/raw/main/RS_198.json
${FILE_NAME}    traffic.json    


*** Tasks ***
Produces traffic data work items
  Download traffic data
  Load traffic data as table
#   Load traffic data as table

*** Keywords ***
Download traffic data
    Create Session    alias=session    url=https://github.com    
    ${response}=    GET On Session    session    /robocorp/inhuman-insurance-inc/raw/main/RS_198.json    
    Should Be Equal As Strings    ${response.status_code}    200
    Log    Successfully fetched data from URL.
    Save JSON To File    ${OUTPUT_DIR}${/}${FILE_NAME}    ${response.text}           
    Log    JSON data saved to ${OUTPUT_DIR}${/}${FILE_NAME}  
     

*** Keywords ***

Save JSON To File
    [Arguments]    ${file_path}    ${content}
    Create File    ${file_path}    ${content}
Load traffic data as table
    ${json}=    Load JSON from file    ${OUTPUT_DIR}${/}traffic.json
    ${table}=    Create Table    ${json}[value]
    RETURN    ${table}    
# Filter and sort traffic data
#     [Arguments]    ${table}
#     Filter Table By Column    ${table}    NumericValue    <    ${5.0}
#     Filter Table By Column    ${table}    Dim1    ==    BTSX
#     Sort Table By Column    ${table}    TimeDim    False
#     RETURN    ${table}    

