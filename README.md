# Local Database Setup and Access Guide

---

## Required MariaDB Setup

### For WSL (Ubuntu/Debian Linux)

1. **Install MariaDB Server**

```bash
sudo apt update
sudo apt install mariadb-server mariadb-client libmariadb-dev build-essential
```

2. **Start MariaDB every time you open a new terminal session**

```bash
sudo service mariadb start
```

3. **Connect as user `alizee` (admin):**

```bash
mysql -u whatever_you_set_in_.env_file -p
# password: (or whatever you set in .env)
```

---

### For macOS (Homebrew)

1. **Install MariaDB**

```bash
brew install mariadb
```

2. **Start the MariaDB service**

```bash
brew services start mariadb
```

3. **Log in as `whatever_you_set_in_.env_file`**

```bash
mysql -u whatever_you_set_in_.env_file -p
```

If the user `whatever_you_set_in_.env_file` does not exist on your system, create it from the MySQL root account:

```sql
CREATE USER 'whatever_you_set_in_.env_file'@'localhost' IDENTIFIED BY '1234';
GRANT ALL PRIVILEGES ON *.* TO 'whatever_you_set_in_.env_file'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
```

---

## Rails Database Configuration

Ensure your `.env` file contains the following:

```env
DB_USERNAME=whatever_you_set
DB_PASSWORD=1234
```

Your `config/database.yml` should include:

```yaml
development:
  adapter: mysql2
  database: developmentdb
  username: <%= ENV["DB_USERNAME"] %>
  password: <%= ENV["DB_PASSWORD"] %>
  host: localhost
  port: 3306
```

---

## Running the Rails Server

Before running the server, **start MariaDB**:

- On Linux/WSL:
  ```bash
  sudo service mysql start
  ```
- On macOS:
  ```bash
  brew services start mariadb
  ```

Then:

```bash
rails server
```

---

## When to Run `db:migrate` and `db:seed`

### Run `rails db:migrate` when:
- You **pull new migration files** from GitHub
- You or another teammate **adds a new column, model, or table**

```bash
rails db:migrate
```

---

### Run `rails db:seed` when:
- You're in **development or test** environments and want to load pre-defined users (e.g., Alice, Bob)
- You've changed `seeds.rb` or `db/seeds/test_seeds.rb`

```bash
rails db:seed
```


---

## Test Users Available After Seeding

| Username     | Password         | Role               |
|--------------|------------------|--------------------|
| Alice        | Password123!     | Developer seed     |
| Bob          | Password123!     | Developer seed     |
| testUser     | Password123!     | Used for CI/testdb |
| anotherUser  | Password456!     | Used for CI/testdb |

