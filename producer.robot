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
# ${NumericValue}     NumericValue 
${YEAR_KEY}         TimeDim
${OUTPUT_CSV}       ${OUTPUT_DIR}\\filtered_test.csv
${output_group}     ${OUTPUT_DIR}\\filtered_group.csv
${output_json}     ${OUTPUT_DIR}\\test.csv
${COUNTRY_KEY}      SpatialDim

*** Tasks ***
Produces traffic data work items
  Download traffic data
  ${table}=    Load traffic data as table
  ${filtered_table}=    Filter and sort traffic data    ${table}
  ${nation}=   Get latest data by country     ${filtered_table}
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
    Write Table To Csv    ${table}    ${output_json}   
    RETURN    ${table}   
    
Filter and sort traffic data
    [Arguments]    ${filtered_table}
    #  ${filtered_by_rate}=    Create List
    # FOR    ${row}    IN    @{filtered_table}
    #     ${value}=    Get From Dictionary    ${row}    NumericValue
    #     ${float_value}=    Evaluate    float(${value})   # Convert value to float
    #     Run Keyword If    ${float_value} < ${MAX_RATE}    Append To List    ${filtered_by_rate}    ${row}
    # END
    # RETURN    ${filtered_by_rate}

    ${table}=    Load traffic data as table
    ${max_rate}=    Set Variable    ${MAX_RATE}
    ${both_genders}=    Set Variable    ${BOTH_GENDERS}

    # Apply first filter: Filter by rate less than max_rate
    # ${filtered_by_rate}=    Filter Table By Column    ${filtered_table}    NumericValue  <   ${max_rate}
    # # Log To Console    filtered_by_rate=${filtered_by_rate}
    # Apply second filter: Filter by gender equals both_genders
    ${filtered_by_gender}=    Filter Table By Column    ${filtered_table}    ${GENDER_KEY}    ==    ${both_genders}

    # # Apply more filters if needed, here you can chain more filters to ${filtered_by_gender}

    # Then, sort the filtered table by year in descending order
    ${sorted_table}=    Sort Table By Column    ${filtered_table}    ${YEAR_KEY}    False
    
    # Log the result to verify
    Log    ${sorted_table}
    # Write filtered data to CSV file
    Write Table To Csv    ${filtered_table}    ${OUTPUT_CSV}
    
    Log    Filtered data saved to ${OUTPUT_CSV}
    
    RETURN    ${filtered_table}

Get latest data by country
    [Arguments]    ${filtered_table}
    ${grouped_by_country}=    Group Table By Column    ${filtered_table}    ${COUNTRY_KEY}
    ${latest_data_by_country}=    Create List

    # Iterate through each country group
    FOR    ${group}    IN    @{grouped_by_country}
        # Pop the first row of each group (assuming it is the latest)
        ${first_row}=    Pop Table Row    ${group}
        Append To List    ${latest_data_by_country}    ${first_row}
    END

    # Convert list to table before writing to CSV
    ${latest_table}=    RPA.Tables.Create Table    ${latest_data_by_country}

    # Write the latest data to CSV file
    Write Table To Csv    ${latest_table}    ${output_group} 

    Log    Latest data by country saved to ${output_group} 
    
    RETURN    ${latest_data_by_country}
