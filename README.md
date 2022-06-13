# PSEdgeTools

> PowerShell scripts to help users interact and configure Microsoft Edge.

*NOTE: This project was inspired by [erbanku/custom-search-engines-backup](https://github.com/erbanku/custom-search-engines-backup).*

View the repo's [Changelog](CHANGELOG.md) for details on the progression of the codebase over time.

## Overview

- Edge Custom Search Engines Settings URL: [edge://settings/searchEngines](http://edge://settings/searchEngines)

- Edge User Profile Directory: `%LOCALAPPDATA%\Microsoft\Edge\Default`
- Edge Database: `%LOCALAPPDATA%\Microsoft\Edge\Default\Web Data`
- Edge `keywords` table is held withing the `sqlite` database mentioned above.

### Scripts

- PowerShell Scripts:
  - [Invoke-ExportEdgeKeywords.ps1](Invoke-ExportEdgeKeywords.ps1): Export Microsoft Edge's `keywords` or custom `searchEngines` to a `SQL` file using `sqlite3`.
  - [Invoke-ImportEdgeKeywords.ps1](Invoke-ImportEdgeKeywords.ps1): Import Microsoft Edge's `keywords` or custom `searchEngines` from a `SQL` file using `sqlite3`.

- SQL Scripts:
  - [`bin/sql_import_script.sql`](bin/sql_import_script.sql): Ran by `sqlite3` to import the `EdgeKeywords.sql` file into the `Web Data` database's `keywords` table.
  - [`bin/sql_export_script.sql`](bin/sql_export_script.sql): Ran by `sqlite3` to export current `Web Data` database's `keywords` table to a `SQL` DDL script: [`EdgeKeywords.sql`](output/EdgeKeywords.sql).

### SQL

Output `.sql` files are exported to [`output/EdgeKeywords.sql`](output/EdgeKeywords.sql). This same `SQL` script can be used for importing back into Edge.

Note that all scripts rely on a dependency for having `sqlite3` installed on your system and on the `PATH` environment variable. Easy installation via `scoop`:

```powershell
scoop install sqlite
```

Another useful tool for viewing the `Web Data` database contents is [sqlitebrowser]() which can be installed via:

```powershell
scoop install sqlitebrowser
```





