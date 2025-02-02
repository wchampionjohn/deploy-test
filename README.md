# Conector

Digital Signage Ad Server that manages and serves advertisements through OpenRTB protocol.

IAB https://github.com/InteractiveAdvertisingBureau/openrtb2.x/blob/develop/2.6.md

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

## DOOH SSP Platform Overview

Conector is a Digital Out-of-Home (DOOH) Supply-Side Platform that enables programmatic buying of digital signage advertising inventory through the OpenRTB protocol. Our platform supports real-time bidding, private marketplace deals, and preferred deals for DOOH advertising spaces.

### Key Features

- **OpenRTB 2.6 Compliance**: Full support for OpenRTB 2.6 protocol with DOOH extensions
- **Flexible Ad Formats**: Support for various digital signage formats including static images, videos, and HTML5
- **Advanced Targeting**: Location-based, time-based, and audience targeting capabilities
- **Real-time Analytics**: Comprehensive reporting and analytics for campaign performance
- **Private Marketplace**: Support for private deals and preferred deals
- **Venue Types**: Support for various DOOH venues including malls, airports, office buildings, etc.

### Integration Guide

For DSP integration, please refer to our detailed documentation:

1. [OpenRTB Implementation Guide](docs/openrtb_guide.md)
2. [API Documentation](docs/api_docs.md)
3. [DOOH Specifications](docs/dooh_specs.md)

### Bid Request Specifications

Our bid requests follow the OpenRTB 2.6 specification with DOOH-specific extensions. Key components include:

- Impression objects with DOOH-specific attributes
- Detailed venue information
- Screen specifications
- Audience metrics
- Geographic targeting capabilities

Example bid request:
```json
{
  "id": "1234567890",
  "imp": [{
    "id": "1",
    "tagid": "screen123",
    "dooh": {
      "venue": "MALL.INDOOR",
      "physical": {
        "w": 1920,
        "h": 1080,
        "unit": "inches",
        "type": "display"
      },
      "playout": {
        "fps": 30,
        "minduration": 5,
        "maxduration": 30
      }
    }
  }]
}
```

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