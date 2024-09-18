# My Salon Appointment Scheduler

This project is a simple salon appointment scheduling system built with a Bash script and PostgreSQL. It allows customers to select services, enter their phone number, and schedule appointments at the salon.

## Project Overview

The script interacts with a PostgreSQL database to manage services, customers, and appointments.

## File

### `salon.sh`

This Bash script allows users to:
- View available salon services.
- Input their phone number to check if they are a returning customer.
- If they are new, the script prompts for their name and records their details.
- Schedule an appointment for the selected service at the specified time.

#### Functionality

1. **Main Menu**: Displays the list of available services.
2. **Customer Interaction**: Prompts the user for their phone number and name if they are new.
3. **Appointment Scheduling**: Allows the user to specify a time for their chosen service and confirms the appointment.

#### Usage

To run the salon appointment scheduling script, use the following command:

```bash
bash salon.sh
