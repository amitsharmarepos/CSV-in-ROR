require 'pry'
require 'csv'
require 'json'

# Function to convert CSV to JSON
def csv_to_json(csv_file_path)
  begin
    products = []

    CSV.foreach(csv_file_path, headers: true) do |row|
      products << {
        'id' => row['id'],
        'name' => row['name'],
        'description' => row['description'],
        'price' => row['price'],
        'availability' => row['availability']
      }
    end

  products.to_json
  rescue Errno::ENOENT => e
    # Handle file not found errors
    puts "CSV file not found: #{e.message}"
    return nil
  end
end

# Usage: Provide the path to your CSV file
csv_file_path = './sample_input/example.csv' # Update with your CSV file path
json_data = csv_to_json(csv_file_path)

# Output the JSON data
puts "=================== JSON Report =================="
puts JSON.pretty_generate(JSON.parse(json_data))
puts "=================================================="

