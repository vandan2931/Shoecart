/**
 * Admin Dashboard JavaScript
 * Handles sidebar toggle, toast notifications, and session messages
 */

// Wait for DOM to be fully loaded
document.addEventListener('DOMContentLoaded', function() {
    // Initialize all components
    initComponents();
});

/**
 * Initialize all dashboard components
 */
function initComponents() {
    initSidebarToggle();
    initToasts();
    showSessionMessages();
}

/**
 * Initialize sidebar toggle functionality
 */
function initSidebarToggle() {
    try {
        const sidebarToggle = document.getElementById('sidebarToggle');
        const sidebar = document.getElementById('sidebar');
        const content = document.getElementById('content');
        
        if (!sidebarToggle || !sidebar || !content) {
            console.warn('Sidebar elements not found');
            return;
        }
        
        // Toggle functionality
        sidebarToggle.addEventListener('click', function() {
            sidebar.classList.toggle('collapsed');
            content.classList.toggle('expanded');
            
            // Store state in localStorage
            localStorage.setItem('sidebarCollapsed', sidebar.classList.contains('collapsed'));
        });
        
        // Restore state from localStorage
        if (localStorage.getItem('sidebarCollapsed') === 'true') {
            sidebar.classList.add('collapsed');
            content.classList.add('expanded');
        }
    } catch (error) {
        console.error('Sidebar initialization error:', error);
    }
}

/**
 * Initialize Bootstrap toast notifications
 */
function initToasts() {
    try {
        // Check if Bootstrap is available
        if (typeof bootstrap === 'undefined' || !bootstrap.Toast) {
            console.warn('Bootstrap Toast not available');
            return;
        }
        
        // Initialize existing toasts
        document.querySelectorAll('.toast').forEach(toastEl => {
            const toast = new bootstrap.Toast(toastEl, {
                autohide: true,
                delay: 5000
            });
            toast.show();
        });
    } catch (error) {
        console.error('Toast initialization error:', error);
    }
}

/**
 * Show session messages as toast notifications
 */
function showSessionMessages() {
    try {
        // Get messages from data attributes (better than JSP expressions in JS)
        const message = document.body.getAttribute('data-message');
        const error = document.body.getAttribute('data-error');
        
        // Show message toast if exists
        if (message && message.trim() !== '') {
            showToast(message, 'success');
            document.body.removeAttribute('data-message');
        }
        
        // Show error toast if exists
        if (error && error.trim() !== '') {
            showToast(error, 'danger');
            document.body.removeAttribute('data-error');
        }
    } catch (error) {
        console.error('Session messages error:', error);
    }
}

/**
 * Create and show a Bootstrap toast notification
 * @param {string} message - The message to display
 * @param {string} type - The type of toast (success, danger, info, warning)
 */
function showToast(message, type = 'info') {
    try {
        // Input validation
        if (!message || typeof message !== 'string') {
            throw new Error('Invalid toast message');
        }
        
        const validTypes = ['success', 'danger', 'info', 'warning'];
        if (!validTypes.includes(type)) {
            type = 'info';
        }
        
        // Create toast container if it doesn't exist
        let container = document.getElementById('toast-container');
        if (!container) {
            container = document.createElement('div');
            container.id = 'toast-container';
            container.className = 'toast-container position-fixed bottom-0 end-0 p-3';
            container.style.zIndex = '1100';
            document.body.appendChild(container);
        }
        
        // Create toast element
        const toastId = 'toast-' + Date.now();
        const toast = document.createElement('div');
        toast.id = toastId;
        toast.className = `toast show align-items-center text-white bg-${type} border-0`;
        toast.setAttribute('role', 'alert');
        toast.setAttribute('aria-live', 'assertive');
        toast.setAttribute('aria-atomic', 'true');
        
        // Toast content
        toast.innerHTML = `
            <div class="d-flex">
                <div class="toast-body">${escapeHtml(message)}</div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" 
                    data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        `;
        
        container.appendChild(toast);
        
        // Initialize and show toast
        const bsToast = new bootstrap.Toast(toast, {
            autohide: true,
            delay: 5000
        });
        
        // Clean up after toast is hidden
        toast.addEventListener('hidden.bs.toast', () => {
            toast.remove();
            if (container.children.length === 0) {
                container.remove();
            }
        });
        
        bsToast.show();
        
    } catch (error) {
        console.error('Toast creation error:', error);
    }
}

/**
 * Helper function to escape HTML in messages
 */
function escapeHtml(unsafe) {
    if (!unsafe) return '';
    return unsafe.toString()
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#039;");
}