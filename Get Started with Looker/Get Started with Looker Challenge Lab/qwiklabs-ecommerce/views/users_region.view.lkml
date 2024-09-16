view: users_region {
  sql_table_name: cloud-training-demos.looker_ecomm.users ;; # Specify the table

  # Primary key
  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  # State dimension
  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  # Country dimension
  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
  }

  # Measure count
  measure: count {
    type: count
    drill_fields: [id, state, country] # Include only the dimensions in drill fields
  }
}
