*** Settings ***
Documentation       Inhuman Insurance, Inc. Artificial Intelligence System robot.
...                 Produces traffic data work items.

Library    RPA.HTTP
Library    RPA.JSON
Library    RPA.Excel.Application
Library    RPA.FileSystem
Library    RPA.Tables
Library    Collections
Library    RPA.Robocorp.WorkItems
Library    RPA.Excel.Files
*** Variables ***
${OUTPUT_DIR}   C:\\Users\\Ponraj\\OneDrive - Yitro Business Consultants India Private Limited\\Pictures\\Saved Pictures
${url}          https://github.com/robocorp/inhuman-insurance-inc/raw/main/RS_198.json
${FILE_NAME}    traffic.json    
# ${TRAFFIC_JSON_FILE_PATH}=      ${OUTPUT_DIR}${/}traffic.json
${MAX_RATE}         5.0
${BOTH_GENDERS}     BTSX
${GENDER_KEY}       Dim1
${RATE_KEY}         NumericValue
${YEAR_KEY}         TimeDim
${OUTPUT_CSV}       ${OUTPUT_DIR}\\filtered_test.csv

*** Tasks ***
Produces traffic data work items
  Download traffic data
  ${table}=    Load traffic data as table
  ${filtered_table}=    Filter and sort traffic data    ${table}
  ${nation}=   Get latest data by country    ${filtered_table}

*** Keywords ***
Download traffic data
    Create Session    alias=session    url=https://github.com    
    ${response}=    GET On Session    session    /robocorp/inhuman-insurance-inc/raw/main/RS_198.json    
    Should Be Equal As Strings    ${response.status_code}    200
    Log    Successfully fetched data from URL.
    Save JSON To File    ${OUTPUT_DIR}${/}${FILE_NAME}    ${response.text}           
    Log    JSON data saved to ${OUTPUT_DIR}${/}${FILE_NAME}  
     
Save JSON To File
    [Arguments]    ${file_path}    ${content}
    RPA.FileSystem.Remove file  ${file_path}         
    Create File    ${file_path}    ${content}
Load traffic data as table
    ${json}=    Load JSON from file    ${OUTPUT_DIR}${/}traffic.json
    ${table}=    RPA.Tables.Create Table    ${json}[value]
    Write Table To Csv    ${table}    test2.csv
    RETURN    ${table}   
    
Filter and sort traffic data
    [Arguments]    ${filtered_table}
    ${table}=    Load traffic data as table
    ${max_rate}=    Set Variable    ${MAX_RATE}
    ${both_genders}=    Set Variable    ${BOTH_GENDERS}

    # Apply first filter: Filter by rate less than max_rate
    # ${filtered_by_rate}=    Filter Table By Column    ${filtered_table}    ${RATE_KEY}    <    ${max_rate}
    # Log To Console    filtered_by_rate=${filtered_by_rate}
    # # Apply second filter: Filter by gender equals both_genders
    ${filtered_by_gender}=    Filter Table By Column    ${filtered_table}    ${GENDER_KEY}    ==    ${both_genders}

    # # Apply more filters if needed, here you can chain more filters to ${filtered_by_gender}

    # Then, sort the filtered table by year in descending order
    ${sorted_table}=    Sort Table By Column    ${filtered_table}    ${YEAR_KEY}    True
    
    # Log the result to verify
    Log    ${sorted_table}
    # Write filtered data to CSV file
    Write Table To Csv    ${filtered_table}    ${OUTPUT_CSV}
    
    Log    Filtered data saved to ${OUTPUT_CSV}
    
    RETURN    ${filtered_table}
  