# Conector

Digital Signage Ad Server that manages and serves advertisements through OpenRTB protocol.

## System Requirements
1. Ruby 3.3.6
2. Rails 8.0
3. PostgreSQL
4. Docker (optional, for containerized deployment)

## Setup

1. Clone the repository git clone [repository-url] cd conector
2. Environment Setup cp .env.example .env

### Update .env with your configuration

3. Install dependencies bundle install
4. Database Setup rails db:create rails db:migrate
5. Run the server forman start -f Procfile.dev

## Project Structure
app/ - Application code  
models/ - Database models and business logic  
controllers/ - Request handlers  
services/ - Complex business operations  
config/ - Configuration files  
db/ - Database migrations and schema  
spec/ - Test files 

## Key Features
1. OpenRTB bid request/response handling
2. Digital signage device management
3. Ad space and unit management
4. VAST response generation
5. Real-time bidding support


## Testing
Run the test suite: bundle exec rspec

## Deployment
This project uses Kamal for deployment. Refer to .kamal/ directory for deployment configurations.

## Code Style
This project follows Rails Omakase style guide. Run Rubocop to check your code: bundle exec rubocop

## Security
Run Brakeman for security analysis: bundle exec brakeman

## Contributing
1. Create a feature branch
2. Write tests
3. Implement your changes
4. Ensure all tests pass
5. Submit a pull request

## License
Privacy Policy