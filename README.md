# wedding-management-project
This comprehensive wedding planner database manages all aspects of wedding planning - from couple details, guest lists, and event scheduling to vendor management, budget tracking, and logistics. It handles multi-day events, accommodations, catering, decorations, transportation, and beauty services.

## 🏰 Project Overview
```sql
/* 
Comprehensive MySQL database for managing:
- Multi-event weddings
- Guest coordination
- Vendor management
- Budget tracking
- Logistics planning
*/
CREATE DATABASE WeddingPlanner;
USE WeddingPlanner;


-- Core Functionality Tables
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'WeddingPlanner';
/*
couple        events       guests      vendors
budget        checklist    seating     gifts
*/
