alter table common_column_config add CONSTRAINT "common_column_config_pkey" PRIMARY KEY ("id");
alter table common_my_email_group add CONSTRAINT "common_my_email_group_pkey" PRIMARY KEY ("id");
alter table common_my_search add CONSTRAINT "common_my_search_pkey" PRIMARY KEY ("id");
alter table common_update_record add CONSTRAINT "common_update_record_pkey" PRIMARY KEY ("id");
alter table common_user_column add CONSTRAINT "common_user_column_pkey" PRIMARY KEY ("id");


alter table dim_mapping_country_customer add CONSTRAINT "dim_mapping_country_customer_pkey" PRIMARY KEY ("id");
alter table dim_mapping_region_country add CONSTRAINT "dim_mapping_region_country_pkey" PRIMARY KEY ("id");
alter table dim_material_demand_offset add CONSTRAINT "dim_material_demand_offset_pkey" PRIMARY KEY ("id");
alter table dim_odm_name add CONSTRAINT "dim_odm_name_pkey" PRIMARY KEY ("id");
alter table dim_plant_mapping add CONSTRAINT "dim_plant_mapping_pkey" PRIMARY KEY ("id");

alter table dim_product_mapping add CONSTRAINT "dim_product_mapping_pkey" PRIMARY KEY ("id");
alter table dim_pss_calendar add CONSTRAINT "dim_pss_calendar_pkey" PRIMARY KEY ("id");
alter table dim_pss_holiday add CONSTRAINT "dim_pss_holiday_pkey" PRIMARY KEY ("id");
alter table dim_pss_holiday_details add CONSTRAINT "dim_pss_holiday_details_pkey" PRIMARY KEY ("id");
alter table dim_pss_save_check_rule add CONSTRAINT "dim_pss_save_check_rule_pkey" PRIMARY KEY ("id");
alter table dim_ramp_up_curve add CONSTRAINT "dim_ramp_up_curve_pkey" PRIMARY KEY ("id");



alter table smart_pss_automation add CONSTRAINT "smart_pss_automation_pkey" PRIMARY KEY ("id");
alter table smart_pss_basic_info add CONSTRAINT "smart_pss_basic_info_pkey" PRIMARY KEY ("id");
alter table smart_pss_detail add CONSTRAINT "smart_pss_detail_pkey" PRIMARY KEY ("id");
alter table smart_pss_detail_ta_schedule add CONSTRAINT "smart_pss_detail_ta_schedule_pkey" PRIMARY KEY ("id");
alter table smart_pss_fit add CONSTRAINT "smart_pss_fit_pkey" PRIMARY KEY ("id");

alter table smart_pss_intelligence add CONSTRAINT "smart_pss_intelligence_pkey" PRIMARY KEY ("id");
alter table smart_pss_line_requirement add CONSTRAINT "smart_pss_line_requirement_pkey" PRIMARY KEY ("id");
alter table smart_pss_project_schedule add CONSTRAINT "smart_pss_project_schedule_pkey" PRIMARY KEY ("id");
alter table sys_log add CONSTRAINT "sys_log_pkey" PRIMARY KEY ("id");


