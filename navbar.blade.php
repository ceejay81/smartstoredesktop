<nav class="navbar navbar-main navbar-expand-lg px-0 mx-4 shadow-none border-radius-xl" id="navbarBlur" navbar-scroll="true">
    <div class="container-fluid py-1 px-3">
        <nav aria-label="breadcrumb">
            <h6 class="font-weight-bolder mb-0">Dashboard</h6>
        </nav>
        
        <ul class="navbar-nav ms-auto">
            <!-- Search Bar -->
            <li class="nav-item d-flex align-items-center">
                <div class="input-group input-group-outline">
                    <input type="text" class="form-control" placeholder="Search...">
                </div>
            </li>
            
            <!-- Notifications -->
            <li class="nav-item dropdown px-3">
                <a href="#" class="nav-link text-body p-0" id="dropdownMenuButton" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="fas fa-bell fa-lg"></i>
                </a>
                <ul class="dropdown-menu dropdown-menu-end px-2 py-3" aria-labelledby="dropdownMenuButton">
                    <li>
                        <a class="dropdown-item" href="#">New notification</a>
                    </li>
                    <li>
                        <a class="dropdown-item" href="#">Another notification</a>
                    </li>
                </ul>
            </li>
            
            <!-- Profile Dropdown -->
            <li class="nav-item dropdown">
                <a href="#" class="nav-link text-body p-0" id="profileDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="fas fa-user-circle fa-lg"></i>
                </a>
                <ul class="dropdown-menu dropdown-menu-end px-2 py-3" aria-labelledby="profileDropdown">
                    <li>
                        <a class="dropdown-item" href="#">Profile</a>
                    </li>
                    <li>
                        <a class="dropdown-item" href="#">Settings</a>
                    </li>
                    <li>
                        <a class="dropdown-item text-danger" href="{{ route('logout') }}"
                           onclick="event.preventDefault(); document.getElementById('logout-form').submit();">
                            Logout
                        </a>
                        <form id="logout-form" action="{{ route('logout') }}" method="POST" class="d-none">
                            @csrf
                        </form>
                    </li>
                </ul>
            </li>

            <!-- Dark Mode Toggle -->
            <li class="nav-item d-flex align-items-center">
                <button id="darkModeToggle" class="btn btn-link px-3 mb-0">
                    <i class="fas fa-moon"></i>
                </button>
            </li>
        </ul>
    </div>
</nav>
