*** Settings ***
Documentation       Inhuman Insurance, Inc. Artificial Intelligence System robot.
...                 Shared settings and code.
Library             RPA.JSON
Library             RPA.Robocorp.WorkItems
Library             RPA.HTTP


*** Variables ***
${WORK_ITEM_NAME}=      traffic_data