# From: https://github.com/rails/dartsass-rails/?tab=readme-ov-file#configuring-sourcemaps
Rails.application.config.dartsass.build_options = [
  '--no-charset',
  '--embed-sources',
  # Ignore the deprecations coming from bootstrap and theme files
  '--silence-deprecation=color-functions',
  '--silence-deprecation=import',
  '--silence-deprecation=global-builtin',
]
