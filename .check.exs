[
  ## all available options with default values (see `mix check` docs for description)
  parallel: true,
  skipped: true,

  ## list of tools (see `mix check` docs for a list of default curated tools)
  tools: [
    {:compiler, "mix compile --warnings-as-errors --force"},
    {:formatter, "mix format --check-formatted", detect: [file: ".formatter.exs"]},
    {:credo, "mix credo --strict", detect: [package: :dark_dev]},
    {:sobelow, "mix sobelow --config", umbrella: [recursive: true], detect: [package: :dark_dev]},
    {:ex_doc, "mix docs", detect: [package: :dark_dev]},
    {:ex_unit, "mix test", detect: [file: "test"]},
    {:dialyzer, "mix dialyzer", detect: [package: :dark_dev]}
  ]
]
