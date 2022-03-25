SELECT setval('ac_group_id_seq', ((SELECT max(id) from ac_group)+1));
SELECT setval('ac_res_id_seq', ((SELECT max(id) from ac_res)+1));
SELECT setval('ac_role_id_seq', ((SELECT max(id) from ac_role)+1));
SELECT setval('ac_user_id_seq', ((SELECT max(id) from ac_user)+1));


SELECT setval('common_user_column_config_seq', ((SELECT max(id) from common_column_config)+1));
SELECT setval('common_my_email_group_id_seq', ((SELECT max(id) from common_my_email_group)+1));
SELECT setval('common_search_id_seq', ((SELECT max(id) from common_my_search)+1));
SELECT setval('common_update_record_id_seq', ((SELECT max(id) from common_update_record)+1));



SELECT setval('datahub_bu_program_schedule_id_seq', ((SELECT max(id) from datahub_bu_program_schedule)+1));
SELECT setval('datahub_business_case_prc_quarterly_id_seq', ((SELECT max(id) from datahub_business_case_prc_quarterly)+1));
SELECT setval('datahub_capacity_plan_id_seq', ((SELECT max(id) from datahub_capacity_plan)+1));
SELECT setval('datahub_customer_mapping_task_detail_id_seq', ((SELECT max(id) from datahub_customer_mapping_task_detail)+1));



SELECT setval('datahub_material_allocation_id_seq', ((SELECT max(id) from datahub_material_allocation)+1));
SELECT setval('datahub_pdp_customer_mapping_id_seq', ((SELECT max(id) from datahub_customer_mapping_pdp)+1));
SELECT setval('datahub_project_schedule_id_seq', ((SELECT max(id) from datahub_project_schedule)+1));
SELECT setval('datahub_project_ta_mapping_id_seq', ((SELECT max(id) from datahub_project_ta_mapping)+1));
SELECT setval('datahub_ta_schedule_id_seq', ((SELECT max(id) from datahub_ta_schedule)+1));
SELECT setval('datahub_tooling_plan_id_seq', ((SELECT max(id) from datahub_tooling_plan)+1));



SELECT setval('dim_factory_capacity_plan_seq', ((SELECT max(id) from dim_factory_capacity_plan_view)+1));
SELECT setval('smart_pss_automation_seq', ((SELECT max(id) from smart_pss_automation)+1));
SELECT setval('smart_pss_detail_id_seq', ((SELECT max(id) from smart_pss_detail)+1));
SELECT setval('smart_pss_detail_ta_schedule_id_seq', ((SELECT max(id) from smart_pss_detail_ta_schedule)+1));
SELECT setval('smart_pss_fit_id_seq', ((SELECT max(id) from smart_pss_fit)+1));
SELECT setval('smart_pss_intelligence_seq', ((SELECT max(id) from smart_pss_intelligence)+1));


SELECT setval('smart_pss_project_schedule_id_seq', ((SELECT max(id) from smart_pss_project_schedule)+1));
SELECT setval('smart_pss_line_requirement_id_seq', ((SELECT max(id) from smart_pss_line_requirement)+1));


SELECT setval('sys_country_customer_id_seq', ((SELECT max(id) from dim_mapping_country_customer)+1));
SELECT setval('sys_dict_id_seq', ((SELECT max(id) from sys_dict)+1));
SELECT setval('sys_factory_capacity_id_seq', ((SELECT max(id) from dim_factory_capacity)+1));
SELECT setval('sys_holiday_id_seq', ((SELECT max(id) from dim_pss_holiday)+1));
SELECT setval('sys_log_id_seq', ((SELECT max(id) from sys_log)+1));


SELECT setval('sys_pss_calendar_id_seq', ((SELECT max(id) from dim_pss_calendar)+1));
SELECT setval('sys_ramp_up_curve_id_seq', ((SELECT max(id) from dim_ramp_up_curve)+1));
SELECT setval('sys_region_country_product_id_seq', ((SELECT max(id) from dim_mapping_region_country)+1));





