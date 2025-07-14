require 'json'

puts "🔧 Generating pet stats table..."

pets_data = []

Dir.glob('data/pets/*.json') do |file|
  pets_data << JSON.parse(File.read(file))
end

# Sort pets by name
pets_data.sort_by! { |p| p['id'] }

# Load row template
row_template = File.read('_includes/templates/pet_row_template.html')

html = <<~HTML
  <table class="pet-stats">
    <thead>
      <tr>
        <th>Pet</th>
        <th>Name</th>
        <th>Base Stats</th>
        <th>Growth per Level</th>
      </tr>
    </thead><tbody>
HTML

pets_data.each do |pet|
  base_stats = pet['base_stats'].map { |k, v| "#{k}: #{v}" }.join("<br>")
  growth_stats = pet['stats_growth'].map { |k, v| "#{k}: #{v}" }.join("<br>")

  row = row_template
    .gsub('{{img}}', pet['img'])
    .gsub('{{name}}', pet['name'])
    .gsub('{{base_stats}}', base_stats)
    .gsub('{{growth_stats}}', growth_stats)

  html << row
end

html << "</tbody></table>"

# Write the generated HTML
File.write('_includes/generated/pet_stats_table.html', html)

puts "✅ Pet stats table generated in _generated/pet_stats_table.html"
