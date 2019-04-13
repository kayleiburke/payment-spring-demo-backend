# PaymentSpring Gateway API
This site is the API portion of a small project built to showcase some web development skills. This API is simple and provides authentication functionality, and well as the API keys for a [PaymentSpring account](https://paymentspring.com/signup) (see [Getting Started](#getting-started) for instructions on setting up a PaymentSpring account). The code for the front end is found [here](https://github.com/kayleiburke/PaymentSpringGatewayPortal). 

The live demo site can be accessed at: https://payment-spring-gateway-portal.herokuapp.com.  

- **Username:**  kaylei.burke@gmail.com
- **Password:** \*paymentspring*


## Getting Started
To run the application:

- Install PostgreSQL from [PostgreSQL Official Page](https://www.postgresql.org/) 
- If you don't have one already, [create a PaymentSpring account](https://paymentspring.com/signup)
- Follow the instructions below (taken from the [PaymentSpring documentation](https://docs.paymentspring.com)) to obtain your PaymentSpring API keys:
    - Log in to https://dashboard.paymentspring.com.
    - Click Account in the navigation menu on the left.
    - You’ll see your current API keys at the bottom of the page. We only allow these keys to show once for security reasons.
    - Click **Generate New Keys**. You can choose to expire the current keys now or in 1 hour.
    - You will see the new set of keys. Save them now, for they will be redacted the next time you visit this page. You can always generate news keys.
- Create the following environment variables:
    - **PAYMENTSPRING_API_KEY**: holds your PaymentSpring public API key 
    - **PAYMENTSPRING_PRIVATE_API_KEY**: holds your PaymentSpring private API key
- Open your terminal
- Navigate to the project
- Run the following commands to set up the environment:
    - `bundle install`
    - `rake db:create`
    - `rake db:migrate`
    - `rake db:seed`
- Start the server by running `rails s`

## Demo API
This code is deployed to https://whispering-cove-68110.herokuapp.com

