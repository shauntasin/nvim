"""Convert existing Android lint XML reports to Neovim quickfix JSON."""
import json
from pathlib import Path
import sys
import xml.etree.ElementTree as ET


def parse_reports(root):
    items, reports = [], []
    # Limit discovery to report directories; never recurse through build outputs.
    candidates = list(root.glob("*/build/reports/lint-results-debug.xml"))
    candidates += list(root.glob("*/*/build/reports/lint-results-debug.xml"))
    for report in sorted(set(candidates)):
        module = report.parent.parent.parent
        reports.append(str(report))
        for issue in ET.parse(report).getroot().findall("issue"):
            severity = issue.get("severity", "Warning")
            if severity == "Ignore":
                continue
            location = issue.find("location")
            file = Path(location.get("file", "")) if location is not None else module
            if not file.is_absolute():
                file = module / file
            items.append({
                "filename": str(file.resolve()),
                "lnum": int(location.get("line", "1")) if location is not None else 1,
                "col": int(location.get("column", "1")) if location is not None else 1,
                "type": "E" if severity in ("Error", "Fatal") else "W" if severity == "Warning" else "I",
                "text": "[{}] {}".format(issue.get("id", "Lint"), issue.get("message", "").replace("\n", " ")),
            })
    if not reports:
        raise ValueError("No debug lint XML reports. Run :AndroidLint, then :AndroidLintResults.")
    items.sort(key=lambda item: (item["type"] != "E", item["filename"], item["lnum"]))
    return {"reports": reports, "items": items}


if __name__ == "__main__":
    try:
        print(json.dumps(parse_reports(Path(sys.argv[1]).resolve())))
    except (OSError, ValueError, ET.ParseError) as error:
        print(str(error), file=sys.stderr)
        sys.exit(1)
