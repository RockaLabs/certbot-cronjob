# Certbot Cron Job

This is a tiny Cron Job workaround for certbot nginx issue related in this [thread](https://github.com/certbot/certbot/issues/5486).

## Solution

Create and configure manually the certificates at nginx using `certonly` certbot method; then just set a custom Cron Job using this [script](renewssl.sh).

### Step 1

Clone, create or copy the content of this repo in you server.

* `/path_to_file/crontab` - Cron command task
* `/path_to_file/renewssl.sh` - Cron Job task
* `/path_to_file/renewssl.logs` - Cron logging file

### Step 2

At `crontab` file properly configure the path to the files `path_to_file`.

```
0 0 1 * * /`path_to_file`/renewssl.sh >> /`path_to_file`/renewssl.logs 2>&1
```

This taks will run every month `0 0 1 * *`, you can set it as you want.


### Step 3

Assign execute permission to `renewssl.sh`.

```
chmod +x /path_to_file/renewssl.sh
```

### Step 5

Set configuration vars at `renewssl.sh`.

```
WEB_SERVICE="nginx"
EMAIL_CERTBOT="user@domain.com"
DOMAINS_CERTBOT="-d domain1.com -d domain2.com -d domain3.com"
PORT="80"
```

### Step 6
Setup crontab taks

```
crontab /path_to_file/crontab
```

You can edit it using `crontab -e`.

If you have followed above steps correctly, your cronjob should be ready :)

---

## Debugging

If you want to test if your cron job is working just follow this steps:

### Step 1

Update your crontab schedule to run every minute `* * * * *`. Open and edit your crontab with: `crontab -e`:

```
* * * * * /`path_to_file`/renewssl.sh >> /`path_to_file`/renewssl.logs 2>&1
```

### Step 2

Just follow the logging file:

```
tail /path_to_file/renewssl.logs -f
```

### Step 3

If everything is fine setup back your crontab schedule (`crontab -e`).

---

Happy coding!