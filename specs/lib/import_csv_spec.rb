
# spec/csv_to_json_spec.rb

require 'csv'
require 'json'
require './lib/import_csv'  # Replace with the actual file name containing your method

describe 'csv_to_json' do
  let(:csv_file_path) { 'sample.csv' }  # Replace with the path to your sample CSV file

  before do
    # Create a sample CSV file for testing
    CSV.open(csv_file_path, 'w') do |csv|
      csv << ['id', 'name', 'description', 'price', 'availability']
      csv << ['1', 'Product 1', 'Description 1', '10.99', 'In Stock']
      csv << ['2', 'Product 2', 'Description 2', '20.49', 'Out of Stock']
    end
  end

  after do
    File.delete(csv_file_path) if File.exist?(csv_file_path)
  end

  it 'parses CSV data and converts it to JSON' do
    json_data = csv_to_json(csv_file_path)
    expected_json = [
      {
        'id' => '1',
        'name' => 'Product 1',
        'description' => 'Description 1',
        'price' => '10.99',
        'availability' => 'In Stock'
      },
      {
        'id' => '2',
        'name' => 'Product 2',
        'description' => 'Description 2',
        'price' => '20.49',
        'availability' => 'Out of Stock'
      }
    ].to_json

    expect(json_data).to eq(expected_json)
  end

  it 'handles an empty CSV file' do
    # Create an empty CSV file
    File.open(csv_file_path, 'w') {}

    json_data = csv_to_json(csv_file_path)

    expect(json_data).to eq('[]')
  end

  it 'handles CSV files with headers but no data' do
    # Create a CSV file with headers but no data rows
    CSV.open(csv_file_path, 'w') do |csv|
      csv << ['id', 'name', 'description', 'price', 'availability']
    end

    json_data = csv_to_json(csv_file_path)

    expect(json_data).to eq('[]')
  end

  it 'handles CSV files with missing columns' do
    # Create a CSV file with missing columns
    CSV.open(csv_file_path, 'w') do |csv|
      csv << ['id', 'name', 'price']
      csv << ['1', 'Product 1', '10.99']
    end

    json_data = csv_to_json(csv_file_path)
    expected_json = [
      {
        'id' => '1',
        'name' => 'Product 1',
        'description' => nil,
        'price' => '10.99',
        'availability' => nil
      }
    ].to_json

    expect(json_data).to eq(expected_json)
  end

  it 'handles CSV file not found error' do
    non_existent_csv_path = './non_existent_file.csv'
    expect { csv_to_json(non_existent_csv_path) }.to output(/CSV file not found/).to_stdout
  end
end
