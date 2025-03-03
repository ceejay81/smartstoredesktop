<aside class="sidenav navbar navbar-vertical navbar-expand-xs border-0 fixed-start bg-white shadow" id="sidenav-main">
    <div class="sidenav-header">
        <i class="fas fa-times p-3 cursor-pointer text-secondary position-absolute end-0 top-0 d-xl-none" id="iconSidenav"></i>
        <a class="navbar-brand m-0 d-flex align-items-center" href="/">
            <i class="fas fa-store me-2 text-dark"></i>
            <span class="ms-1 fw-bold text-dark">SmartStore</span>
        </a>
    </div>
    <hr class="horizontal light mt-0 mb-2">
    <div class="collapse navbar-collapse w-auto" id="sidenav-collapse-main">
        <ul class="navbar-nav">
            <!-- Main -->
            <li class="nav-header text-uppercase text-muted px-3 py-2 small">Main</li>
            <li class="nav-item">
                <a class="nav-link d-flex align-items-center {{ request()->is('dashboard') ? 'active' : '' }}" href="/dashboard">
                    <i class="fas fa-tachometer-alt me-2 text-primary"></i>
                    <span class="text-dark">Dashboard</span>
                </a>
            </li>

            <!-- Inventory Section -->
            <li class="nav-item">
                <a class="nav-link d-flex align-items-center justify-content-between" data-bs-toggle="collapse" href="#inventorySubmenu">
                    <div>
                        <i class="fas fa-boxes me-2 text-warning"></i>
                        <span class="text-dark">Inventory</span>
                    </div>
                    <i class="fas fa-chevron-down small"></i>
                </a>
                <div class="collapse show" id="inventorySubmenu"> <!-- Added 'show' class here -->
                    <ul class="nav ms-4 mt-1">
                        <li class="nav-item">
                            <a class="nav-link py-1" href="/inventory/products">Products</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link py-1" href="/inventory/categories">Categories</a>
                        </li>
                    </ul>
                </div>
            </li>

            <!-- Management -->
            <li class="nav-header text-uppercase text-muted px-3 py-2 small mt-3">Management</li>
            <li class="nav-item">
                <a class="nav-link d-flex align-items-center {{ request()->is('sales') ? 'active' : '' }}" href="/sales">
                    <i class="fas fa-chart-line me-2 text-success"></i>
                    <span class="text-dark">Sales</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link d-flex align-items-center {{ request()->is('reports') ? 'active' : '' }}" href="/reports">
                    <i class="fas fa-file-alt me-2 text-info"></i>
                    <span class="text-dark">Reports</span>
                </a>
            </li>

            <!-- Administration -->
            <li class="nav-header text-uppercase text-muted px-3 py-2 small mt-3">Administration</li>
            <li class="nav-item">
                <a class="nav-link d-flex align-items-center {{ request()->is('users') ? 'active' : '' }}" href="/users">
                    <i class="fas fa-users me-2 text-danger"></i>
                    <span class="text-dark">Users</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link d-flex align-items-center {{ request()->is('settings') ? 'active' : '' }}" href="/settings">
                    <i class="fas fa-cog me-2 text-secondary"></i>
                    <span class="text-dark">Settings</span>
                </a>
            </li>
        </ul>
    </div>

    <!-- User Profile Section -->
    <div class="position-absolute bottom-0 w-100 mb-3">
        <hr class="horizontal dark">
        <div class="px-3">
            <div class="d-flex align-items-center">
                <div class="avatar avatar-sm rounded-circle bg-secondary me-2">
                    <i class="fas fa-user text-white"></i>
                </div>
                <div class="flex-grow-1">
                    <h6 class="mb-0 text-sm">{{ Auth::user()->name }}</h6>
                    <p class="mb-0 text-xs text-muted">{{ Auth::user()->email }}</p>
                </div>
            </div>
        </div>
    </div>
</aside>