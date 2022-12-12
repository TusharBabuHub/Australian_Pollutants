# create data model
dm_npi <-
  dm(
    `anzsic-2006`,
    `emission-reduction-techniques`,
    emissions,
    facilities,
    `facility-secondary-anzsics`,
    reports,
    substances,
    `transfer-destinations`,
    transfers
  )

# set primary key/s for each dataframe
# implemented from the data dictionary
dm_npi <- dm_npi %>%
  dm_add_pk(`anzsic-2006`, class_code) %>%
  dm_add_pk(`emission-reduction-techniques`,
            c(report_id, reduction_technique_id)) %>%
  dm_add_pk(emissions, c(substance_id, report_id)) %>%
  dm_add_pk(facilities, facility_id) %>%
  dm_add_pk(`facility-secondary-anzsics`,
            c(facility_id, anzsic_class_code)) %>%
  dm_add_pk(reports, report_id) %>%
  dm_add_pk(substances, substance_id) %>%
  dm_add_pk(`transfer-destinations`, transfer_destination_id) %>%
  dm_add_pk(transfers,
            c(report_id
              , substance_id
              , transfer_destination_id))

# set foreign key/s for each dataframe with respect to the others
dm_npi <- dm_npi %>%
  dm_add_fk(`facility-secondary-anzsics`,
            anzsic_class_code,
            `anzsic-2006`,
            class_code) %>%
  dm_add_fk(reports, primary_anzsic_class_code, `anzsic-2006`, class_code) %>%
  dm_add_fk(transfers,
            primary_anzsic_class_code,
            `anzsic-2006`,
            class_code) %>%
  dm_add_fk(facilities,
            primary_anzsic_class_code,
            `anzsic-2006`,
            class_code) %>%
  dm_add_fk(emissions,
            primary_anzsic_class_code,
            `anzsic-2006`,
            class_code) %>%
  dm_add_fk(
    emissions,
    c(
      facility_id,
      facility_name,
      jurisdiction_code,
      registered_business_name
    ),
    facilities,
    c(
      facility_id,
      facility_name,
      jurisdiction_code,
      registered_business_name
    )
  ) %>%
  dm_add_fk(
    `emission-reduction-techniques`,
    c(facility_id, jurisdiction_code),
    facilities,
    c(facility_id, jurisdiction_code)
  ) %>%
  dm_add_fk(
    reports,
    c(
      facility_id,
      facility_name,
      jurisdiction_code,
      jurisdiction_facility_id,
      registered_business_name
    ),
    facilities,
    c(
      facility_id,
      facility_name,
      jurisdiction_code,
      jurisdiction_facility_id,
      registered_business_name
    )
  ) %>%
  dm_add_fk(
    transfers,
    c(
      facility_id,
      facility_name,
      jurisdiction_code,
      jurisdiction_facility_id,
      registered_business_name
    ),
    facilities,
    c(
      facility_id,
      facility_name,
      jurisdiction_code,
      jurisdiction_facility_id,
      registered_business_name
    )
  ) %>%
  dm_add_fk(`facility-secondary-anzsics`,
            facility_id,
            facilities,
            facility_id) %>%
  dm_add_fk(transfers,
            substance_id,
            substances,
            substance_id) %>%
  dm_add_fk(emissions,
            substance_id,
            substances,
            substance_id) %>%
  dm_add_fk(
    transfers,
    transfer_destination_id,
    `transfer-destinations`,
    transfer_destination_id
  ) %>%
  dm_add_fk(emissions,
            c(report_id, report_year),
            reports,
            c(report_id, report_year)) %>%
  dm_add_fk(
    `emission-reduction-techniques`,
    c(report_id, report_year),
    reports,
    c(report_id, report_year)
  ) %>%
  dm_add_fk(transfers,
            c(report_id, report_year),
            reports,
            c(report_id, report_year))

dm_npi  %>%
  dm_set_colors(
    steelblue = contains('emission'),
    darkorchid = contains('facilit'),
    deeppink = contains('transfer'),
    gold = contains('2006'),
    darkred = contains('substances'),
    chocolate = contains('report'),
    forestgreen = contains('reduction')
  ) %>%
  dm_draw(graph_attrs = "rankdir = RL, bgcolor = '#000'",
          edge_attrs = "dir = both, arrowtail = crow, arrowhead = odiamond, color = '#F4F0EF'",
          node_attrs = "fontname = 'Arial'",
          view_type = "title_only") %>%
  export_svg() %>%
  write(file = 'images/dm_graph.svg')

