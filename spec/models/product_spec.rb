RSpec.describe Product, type: :model do
  # Title
  it "is not valid without a title" do
    product = Product.new(title: nil)
    expect(product).not_to be_valid
    expect(product.errors[:title]).to include("can't be blank")
  end

  it "is not valid with a title that is too short" do
    product = Product.new(title: "a" * 4)
    expect(product).not_to be_valid
    expect(product.errors[:title]).to include("is too short (minimum is 5 characters)")
  end

  it "is not valid with a title that is too long" do
    product = Product.new(title: "a" * 51)
    expect(product).not_to be_valid
    expect(product.errors[:title]).to include("is too long (maximum is 50 characters)")
  end

  # description
  it "is not valid without a description" do
    product = Product.new(description: nil)
    expect(product).not_to be_valid
    expect(product.errors[:description]).to include("can't be blank")
  end

  it "is not valid with a description that is too short" do
    product = Product.new(description: "a" * 4)
    expect(product).not_to be_valid
    expect(product.errors[:description]).to include("is too short (minimum is 5 characters)")
  end

  it "is not valid with a description that is too long" do
    product = Product.new(description: "a" * 401)
    expect(product).not_to be_valid
    expect(product.errors[:description]).to include("is too long (maximum is 400 characters)")
  end

  # price
  it "is not valid without a price" do
    product = Product.new(price: nil)
    expect(product).not_to be_valid
    expect(product.errors[:price]).to include("is not a number")
  end

  it "is not valid with a price that is too low" do
    product = Product.new(price: 4)
    expect(product).not_to be_valid
    expect(product.errors[:price]).to include("must be greater than or equal to 10000")
  end

  it "is not valid with a price that is too high" do
    product = Product.new(price: 20000000)
    expect(product).not_to be_valid
    expect(product.errors[:price]).to include("must be less than or equal to 10000000")
  end

  # city
  it "is not valid without a city" do
    product = Product.new(city: nil)
    expect(product).not_to be_valid
    expect(product.errors[:city]).to include("can't be blank")
  end

  it "is not valid with a city that is too short" do
    product = Product.new(city: "a" * 2)
    expect(product).not_to be_valid
    expect(product.errors[:city]).to include("is too short (minimum is 3 characters)")
  end

  it "is not valid with a city that is too long" do
    product = Product.new(city: "a" * 401)
    expect(product).not_to be_valid
    expect(product.errors[:city]).to include("is too long (maximum is 100 characters)")
  end

  # property_type
  it "is not valid without a property_type" do
    product = Product.new(property_type: nil)
    expect(product).not_to be_valid
    expect(product.errors[:property_type]).to include("can't be blank")
  end

  # category
  it "is not valid without a category" do
    product = Product.new(category: nil)
    expect(product).not_to be_valid
    expect(product.errors[:category]).to include("can't be blank")
  end

  # number_of_floors
  it "is not valid without a number of floors" do
    product = Product.new(number_of_floors: nil)
    expect(product).not_to be_valid
    expect(product.errors[:number_of_floors]).to include("is not a number")
  end

  it "is not valid with a non-integer number of floors" do
    product = Product.new(number_of_floors: 3.5)
    expect(product).not_to be_valid
    expect(product.errors[:number_of_floors]).to include("must be an integer")
  end

  it "is not valid with a number of floors less than 0" do
    product = Product.new(number_of_floors: -1)
    expect(product).not_to be_valid
    expect(product.errors[:number_of_floors]).to include("must be greater than or equal to 0")
  end

  it "is not valid with a number of floors greater than 50" do
    product = Product.new(number_of_floors: 51)
    expect(product).not_to be_valid
    expect(product.errors[:number_of_floors]).to include("must be less than or equal to 50")
  end

  # energy_performance_diagnostic
  it "is not valid without a energy_performance_diagnostic" do
    product = Product.new(energy_performance_diagnostic: nil)
    expect(product).not_to be_valid
    expect(product.errors[:energy_performance_diagnostic]).to include("can't be blank")
  end

  # area
  it "is not valid without a area" do
    product = Product.new(area: nil)
    expect(product).not_to be_valid
    expect(product.errors[:area]).to include("is not a number")
  end

  it "is not valid with a area less than 9" do
    product = Product.new(area: 3)
    expect(product).not_to be_valid
    expect(product.errors[:area]).to include("must be greater than or equal to 9")
  end

  it "is not valid with a area greater than 1500" do
    product = Product.new(area: 1501)
    expect(product).not_to be_valid
    expect(product.errors[:area]).to include("must be less than or equal to 1500")
  end

  # number_of_rooms
  it "is not valid without a number of rooms" do
    product = Product.new(number_of_rooms: nil)
    expect(product).not_to be_valid
    expect(product.errors[:number_of_rooms]).to include("is not a number")
  end

  it "is not valid with a non-integer number of rooms" do
    product = Product.new(number_of_rooms: 3.5)
    expect(product).not_to be_valid
    expect(product.errors[:number_of_rooms]).to include("must be an integer")
  end

  it "is not valid with a number of rooms less than 1" do
    product = Product.new(number_of_rooms: 0)
    expect(product).not_to be_valid
    expect(product.errors[:number_of_rooms]).to include("must be greater than or equal to 1")
  end

  it "is not valid with a number of rooms greater than 25" do
    product = Product.new(number_of_rooms: 31)
    expect(product).not_to be_valid
    expect(product.errors[:number_of_rooms]).to include("must be less than or equal to 25")
  end
end
