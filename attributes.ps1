Class MinBranch : Attribute {
    [string]$Branch

    MinBranch([string]$Branch) {
        $this.Branch = $Branch;
    }
}