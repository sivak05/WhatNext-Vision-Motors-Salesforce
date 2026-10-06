# 🚗 WhatNext Vision Motors

### Salesforce CRM Implementation – Shaping the Future of Mobility

![Salesforce](https://img.shields.io/badge/Salesforce-Developer%20Edition-00A1E0?logo=salesforce&logoColor=white)
![Apex](https://img.shields.io/badge/Apex-Triggers%20%26%20Batch-1798C1)
![Flow](https://img.shields.io/badge/Flow-Record--Triggered-032D60)
![Program](https://img.shields.io/badge/Naan%20Mudhalvan-Project-orange)

A Salesforce CRM solution for **WhatNext Vision Motors** that streamlines vehicle ordering, prevents orders for out-of-stock vehicles, automatically assigns the nearest dealer, and keeps order statuses up to date through scheduled batch processing.

---

## 📑 Table of Contents

- [About the Project](#-about-the-project)
- [Team](#-team)
- [Key Features](#-key-features)
- [Data Model](#-data-model)
- [Automation and Code](#-automation-and-code)
- [Project Milestones](#-project-milestones)
- [Setup Guide](#-setup-guide)
- [Testing the Solution](#-testing-the-solution)
- [What We Learned](#-what-we-learned)
- [Acknowledgements](#-acknowledgements)

---

## 📌 About the Project

WhatNext Vision Motors is an automotive company focused on customer-first mobility solutions. This project improves the **customer ordering experience** and reduces the **administrative workload** on staff by:

- Automatically suggesting and assigning the nearest dealer based on the customer's address.
- Blocking orders for vehicles that are out of stock.
- Running a scheduled process that updates bulk order statuses: **Pending** when stock is unavailable, **Confirmed** once stock is available.
- Sending automated email reminders for scheduled test drives.

---

## 👥 Team

**Program:** Naan Mudhalvan
**Institution:** A.V.C. College of Engineering
**College Code:** 8203

| Role | Name | NM ID |
|------|------|-------|
| 👑 Team Leader | **K. Siva** | `70CF1E8694019C2B720484EFFF6C1779` |
| Team Member | Sivarajaganapathi S | `4D2198FA90720AD8F834BBD4C69121C9` |
| Team Member | Sheik Abdulla M I | `91C4E215B13B46C852742463932E5FB9` |
| Team Member | Senthamizhan | `8CE2DC2CF6A1FBC9FDD415138FD7AD55` |
| Team Member | Selvaganapathy N | `7A4D88912130BA0A759424ABE7A0FD32` |

---

## ✨ Key Features

| Feature | Description |
|---------|-------------|
| 🗂️ Centralized data | Vehicles, stock, dealers, customers, orders, test drives and service requests stored in Salesforce |
| 📍 Nearest dealer assignment | Record-triggered flow assigns a dealer to each new order based on the customer's address |
| 🚫 Stock validation | Apex trigger blocks orders when `Stock_Quantity__c` is 0 or less |
| 🔄 Nightly order processing | Batch Apex confirms pending orders once stock is available |
| 📧 Test drive reminders | Scheduled flow emails the customer one day before the test drive |
| 📱 Lightning App | Custom *WhatNext Vision Motors* app with tabs for all objects, reports and dashboards |

---

## 🧱 Data Model

| Object | Purpose | Related To |
|--------|---------|------------|
| `Vehicle__c` | Vehicle details and stock | Dealer, Orders |
| `Vehicle_Dealer__c` | Authorized dealer information | Orders |
| `Vehicle_Customer__c` | Customer details | Orders, Test Drives |
| `Vehicle_Order__c` | Vehicle purchases | Customer, Vehicle, Dealer |
| `Vehicle_Test_Drive__c` | Test drive bookings | Customer, Vehicle |
| `Vehicle_Service_Request__c` | Servicing requests | Customer, Vehicle |

### Key Fields

<details>
<summary><b>Click to expand field list</b></summary>

**Vehicle__c**
- `Vehicle_Model__c` (Picklist: Sedan, SUV, EV)
- `Stock_Quantity__c` (Number)
- `Price__c` (Currency)
- `Dealer__c` (Lookup → Vehicle_Dealer__c)
- `Status__c` (Picklist: Available, Out of Stock, Discontinued)

**Vehicle_Dealer__c**
- `Dealer_Name__c`, `Dealer_Location__c`, `Dealer_Code__c` (Auto Number), `Phone__c`, `Email__c`

**Vehicle_Customer__c**
- `Customer_Name__c`, `Email__c`, `Phone__c`, `Address__c`, `Preferred_Vehicle_Type__c`

**Vehicle_Order__c**
- `Vehicle_Customer__c`, `Vehicle__c`, `Dealer__c` (Lookups)
- `Order_Date__c` (Date)
- `Status__c` (Picklist: Pending, Confirmed, Delivered, Canceled)

**Vehicle_Test_Drive__c**
- `Vehicle_Customer__c`, `Vehicle__c` (Lookups)
- `Test_Drive_Date__c` (Date)
- `Status__c` (Picklist: Scheduled, Completed, Canceled)

**Vehicle_Service_Request__c**
- `Vehicle_Customer__c`, `Vehicle__c` (Lookups)
- `Service_Date__c` (Date), `Issue_Description__c` (Text)
- `Status__c` (Picklist: Requested, In Progress, Completed)

</details>

---

## ⚙️ Automation and Code

### Flows

| Flow | Object | Trigger | Purpose |
|------|--------|---------|---------|
| **Auto Assign Dealer** | Vehicle Order | Record created, `Status__c = Pending` | Looks up the customer, finds the dealer matching the customer's address, and updates the order's `Dealer__c` |
| **Test Drive Reminder** | Vehicle Test Drive | Created or updated, `Status__c = Scheduled` | Scheduled path 1 day before `Test_Drive_Date__c` sends a reminder email to the customer |

### Apex

| Component | Type | Description |
|-----------|------|-------------|
| `VehicleOrderTrigger` | Trigger | Runs before/after insert and update on `Vehicle_Order__c` and delegates to the handler |
| `VehicleOrderTriggerHandler` | Handler class | Blocks out-of-stock orders (`addError`) and reduces stock when an order is confirmed |
| `VehicleOrderBatch` | Batch Apex | Finds `Pending` orders, confirms those with available stock and reduces stock by 1 |
| `VehicleOrderBatchScheduler` | Schedulable | Runs the batch job with a batch size of 50 |

Schedule the nightly job (runs daily at 12:00 AM) from **Developer Console → Debug → Open Execute Anonymous Window**:

```apex
String cronExp = '0 0 0 * * ?';
System.schedule('Daily Vehicle Order Processing', cronExp, new VehicleOrderBatchScheduler());
```

---

## 🏁 Project Milestones

1. **Developer Account** – Create and activate a Salesforce Developer Edition org
2. **Objects and Relationships** – Create the six custom objects
3. **Tabs** – Create custom tabs for each object
4. **Lightning App** – Build the *WhatNext Vision Motors* app
5. **Fields and Relationships** – Add fields and lookup relationships
6. **Record-Triggered Flows** – Auto-assign dealer and test drive reminder email
7. **Apex, Triggers and Batch Jobs** – Stock validation, trigger handler, batch job and scheduler

---

## 🛠️ Setup Guide

1. Sign up for a free org at <https://developer.salesforce.com/signup> and verify your account.
2. Create the six custom objects, tabs and fields listed in the [Data Model](#-data-model).
3. Create the **WhatNext Vision Motors** Lightning App and add the object tabs, Reports and Dashboard.
4. Add the `Dealer__c` lookup on **Vehicle Order** *before* building the Auto Assign Dealer flow.
5. Build and activate both flows (**Auto Assign Dealer** and **Test Drive Reminder**).
6. In the Developer Console, create the Apex classes and trigger from the `force-app` folder.
7. Run the scheduling snippet above, then confirm the job under **Setup → Scheduled Jobs**.

---

## 🧪 Testing the Solution

| Scenario | Expected Result |
|----------|-----------------|
| Create an order for a vehicle with `Stock_Quantity__c = 0` | Error: *This vehicle is out of stock. Order cannot be placed.* |
| Create an order with `Status = Pending` for a customer | `Dealer__c` is filled with the matching dealer |
| Add stock to a vehicle and run the batch job | Pending orders become **Confirmed** and stock decreases |
| Create a test drive with `Status = Scheduled` | Customer receives a reminder email one day before the date |

---

## 📚 What We Learned

- Data modelling, fields and relationships
- Lightning App Builder
- Record-triggered flows
- Apex and Apex triggers with the handler pattern
- Batch Apex and Scheduled Apex

---

## 🙏 Acknowledgements

Developed as part of the **Naan Mudhalvan** program at **A.V.C. College of Engineering** (College Code: 8203).

---

<p align="center">Made with ❤️ by Team WhatNext Vision Motors</p>
