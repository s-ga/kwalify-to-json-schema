module KwalifyToJsonSchema

  # Convert a Kwalify schema file to JSON .schema.
  # The destination file can be JSON or YAML.
  # The file extension is used to select the format: .json or .yaml.
  # Other extension will fallback to JSON.
  # Converter options:
  # | Name                  | Type   | Default value| Description                                                                              |
  # |-----------------------|--------|--------------|------------------------------------------------------------------------------------------|
  # | :id                   | string | nil          | The JSON schema identifier                                                               |
  # | :title                | string | nil          | The JSON schema title                                                                    |
  # | :description          | string | nil          | The JSON schema description. If not given the Kwalify description will be used if present|
  # | :issues_to_description| boolean| false        | To append the issues to the JSON schema description                                      |
  # | :issues_to_stderr     | boolean| false        | To write the issues to standard error output                                             |
  # | :custom_processing    | object | nil          | To customize the conversion                                                              |
  # | :schema_version       | string | "draft-04"   | JSON schema version. Changing this value only change the value of $schema field          |
  # | :verbose              | boolean| false        | To be verbose when converting                                                            |
  # --
  # @param source Path to Kwalify YAML schema
  # @param dest Path to resulting JSON schema
  def self.convert_file(source, dest, options = {})
    options = Options.new(options)
    puts "Converting file://#{File.expand_path source } to file://#{File.expand_path dest}" if options.verbose?

    # Get a converter
    converter = Converter.new(options)
    # Convert
    converted = converter.exec(Serialization.deserialize_from_file(source))
    # Serialize
    Serialization.serialize_to_file(dest, converted)
  end

  # Convert a Kwalify schema string to JSON .schema.
  # The source and destination strings can be JSON or YAML.
  # Other extension will fallback to JSON.
  # Converter options:
  # | Name                  | Type   | Default value| Description                                                                              |
  # |-----------------------|--------|--------------|------------------------------------------------------------------------------------------|
  # | :id                   | string | nil          | The JSON schema identifier                                                               |
  # | :title                | string | nil          | The JSON schema title                                                                    |
  # | :description          | string | nil          | The JSON schema description. If not given the Kwalify description will be used if present|
  # | :issues_to_description| boolean| false        | To append the issues to the JSON schema description                                      |
  # | :issues_to_stderr     | boolean| false        | To write the issues to standard error output                                             |
  # | :custom_processing    | object | nil          | To customize the conversion                                                              |
  # | :schema_version       | string | "draft-04"   | JSON schema version. Changing this value only change the value of $schema field          |
  # | :verbose              | boolean| false        | To be verbose when converting                                                            |
  # --
  # @param kwalify_schema Kwalify schema as YAML or JSON
  # @param source_format format of the source schema
  # @param dest_format format of the destination schema
  # @param options
  def self.convert_string(kwalify_schema, source_format = "yaml", dest_format = "json", options = {})
    options = Options.new(options)
    # Get a converter
    converter = Converter.new(options)
    # Convert
    converted = converter.exec(Serialization.deserialize_from_string(kwalify_schema, source_format))
    # Serialize
    Serialization.serialize_to_string(converted, dest_format)
  end
end
