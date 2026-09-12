/* ==========================================================================
   UNIFIED GOVERNMENT SERVICES PORTAL (UGSP) / GOVERNMENT INTEROPERABILITY HUB
   Interactive Application Controller & Screen Routing Engine
   ========================================================================== */

(function () {
  'use strict';

  // App State
  const AppState = {
    currentRole: 'citizen', // 'citizen' | 'officer' | 'admin'
    currentScreen: 'screen-citizen-dashboard',
    citizen: portalData.citizenProfile,
    departments: portalData.departments,
    services: portalData.services,
    applications: portalData.applications,
    documents: portalData.digilockerVault,
    consents: portalData.dpdpConsents,
    syncLedger: portalData.syncAuditLedger,
    notifications: portalData.notifications,
    
    // Dynamic Application Wizard State
    wizard: {
      selectedServiceId: 'SRV-AGRI-001',
      currentStep: 1, // 1: Citizen Pre-fill, 2: Dept Dynamic Fields, 3: Document Proofs, 4: DPDP Consent & Review
      formData: {},
      attachedDocs: ['DOC-AADHAAR-8921', 'DOC-PAN-7712', 'DOC-712-9901']
    },

    // Guided Tour State
    tour: {
      activeStepIndex: 0,
      steps: [
        { title: '1. Citizen Single Sign-On', screen: 'screen-login-auth', desc: 'Citizen Krisha Patel authenticates via Unified Parichay / Aadhaar OTP.' },
        { title: '2. Citizen Command Dashboard', screen: 'screen-citizen-dashboard', desc: 'Single unified dashboard showing inter-department metrics, active requests, and verified credentials.' },
        { title: '3. DigiLocker Pre-filled Profile', screen: 'screen-my-profile', desc: 'Unified citizen profile consolidated from UIDAI, Revenue, and PMC registries.' },
        { title: '4. DPDP Act Consent Engine', screen: 'screen-consent-mgmt', desc: 'Granular, legally-binding consent control under Digital Personal Data Protection Act 2023.' },
        { title: '5. Inter-Dept Live Sync Hub', screen: 'screen-live-sync', desc: 'Demonstrates real-time API mesh synchronizing PMC, Revenue, MahaBhumi, and Bank DBT.' },
        { title: '6. Unified Service Catalog', screen: 'screen-service-catalog', desc: 'Over 450+ state services federated under one searchable, filterable catalog.' },
        { title: '7. Dynamic Auto-Eligibility', screen: 'screen-service-details', desc: 'Instant automated pre-eligibility verification before the citizen even applies.' },
        { title: '8. 1-Click Smart Application', screen: 'screen-service-wizard', desc: 'Dynamic form engine auto-pulling 85% of data from verified state vaults.' },
        { title: '9. Immutable Audit Ledger', screen: 'screen-sync-audit', desc: 'SHA-256 cryptographically anchored audit trail tracking every cross-dept data pull.' },
        { title: '10. Officer Scrutiny Console', screen: 'screen-officer-dashboard', desc: 'Department Admin verifies applicant data with cross-department verified badges.' },
        { title: '11. Admin Dynamic Builder', screen: 'screen-admin-form-builder', desc: 'System Admin configures zero-code schema fields and business rules with live preview.' },
        { title: '12. Macro Delivery Analytics', screen: 'screen-admin-analytics', desc: 'State-level SLA performance, throughput metrics, and departmental bottleneck heatmaps.' }
      ]
    }
  };

  // DOM Elements cache
  const elements = {};

  function initElements() {
    elements.roleSwitchBtns = document.querySelectorAll('[data-role-switch]');
    elements.navItemBtns = document.querySelectorAll('.nav-item-btn');
    elements.viewPanes = document.querySelectorAll('.view-pane');
    elements.activeRoleLabel = document.getElementById('active-role-label');
    elements.userNameDisplay = document.getElementById('user-name-display');
    elements.userIdDisplay = document.getElementById('user-id-display');
    elements.userAvatar = document.getElementById('user-avatar');
    elements.toast = document.getElementById('gov-toast');
    elements.toastMessage = document.getElementById('toast-message');
    elements.modalBackdrop = document.getElementById('gov-modal-backdrop');
    elements.modalTitle = document.getElementById('modal-title');
    elements.modalBody = document.getElementById('modal-body');
    elements.modalConfirmBtn = document.getElementById('modal-confirm-btn');
    elements.modalCloseBtn = document.getElementById('modal-close-btn');
    elements.contrastToggle = document.getElementById('toggle-contrast');
    elements.fontIncrease = document.getElementById('font-increase');
    elements.fontDecrease = document.getElementById('font-decrease');
    elements.fontReset = document.getElementById('font-reset');
  }

  // Toast Helper
  function showToast(msg, isSuccess = true) {
    if (!elements.toast) return;
    elements.toastMessage.textContent = msg;
    elements.toast.style.borderLeftColor = isSuccess ? 'var(--gov-green)' : 'var(--gov-saffron)';
    elements.toast.classList.add('show');
    setTimeout(() => {
      elements.toast.classList.remove('show');
    }, 3800);
  }

  // Modal Helper
  function showModal(title, htmlContent, onConfirm) {
    if (!elements.modalBackdrop) return;
    elements.modalTitle.textContent = title;
    elements.modalBody.innerHTML = htmlContent;
    elements.modalBackdrop.classList.add('open');
    
    elements.modalConfirmBtn.onclick = () => {
      if (onConfirm) onConfirm();
      closeModal();
    };
  }

  function closeModal() {
    if (elements.modalBackdrop) {
      elements.modalBackdrop.classList.remove('open');
    }
  }

  // Screen Routing
  function navigateToScreen(screenId) {
    AppState.currentScreen = screenId;
    
    // Hide all view panes
    elements.viewPanes.forEach(pane => pane.classList.remove('active'));
    
    // Show active pane
    const targetPane = document.getElementById(screenId);
    if (targetPane) {
      targetPane.classList.add('active');
    }

    // Update active nav button
    elements.navItemBtns.forEach(btn => {
      if (btn.getAttribute('data-target-screen') === screenId) {
        btn.classList.add('active');
      } else {
        btn.classList.remove('active');
      }
    });

    // Render screen specific components
    renderScreen(screenId);
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }

  // Role Switching Engine
  function switchRole(role) {
    AppState.currentRole = role;

    // Update role buttons
    elements.roleSwitchBtns.forEach(btn => {
      if (btn.getAttribute('data-role-switch') === role) {
        btn.classList.add('active');
      } else {
        btn.classList.remove('active');
      }
    });

    // Update Sidebar Navigation visibility
    document.querySelectorAll('[data-role-section]').forEach(sec => {
      const allowedRoles = sec.getAttribute('data-role-section').split(',');
      if (allowedRoles.includes(role)) {
        sec.style.display = 'block';
      } else {
        sec.style.display = 'none';
      }
    });

    // Update header identity
    if (role === 'citizen') {
      elements.activeRoleLabel.textContent = 'Citizen Account';
      elements.userNameDisplay.textContent = AppState.citizen.name;
      elements.userIdDisplay.textContent = AppState.citizen.citizenId;
      elements.userAvatar.textContent = 'KP';
      navigateToScreen('screen-citizen-dashboard');
      showToast(`Logged in as Citizen: ${AppState.citizen.name}`);
    } else if (role === 'officer') {
      elements.activeRoleLabel.textContent = 'Department Officer (PMC & Agri)';
      elements.userNameDisplay.textContent = 'Suresh Patil (Desk Officer)';
      elements.userIdDisplay.textContent = 'MH-OFFICER-4402';
      elements.userAvatar.textContent = 'SP';
      navigateToScreen('screen-officer-dashboard');
      showToast('Switched to Department Admin & Verification Desk');
    } else if (role === 'admin') {
      elements.activeRoleLabel.textContent = 'State System Administrator';
      elements.userNameDisplay.textContent = 'Dr. Anand Deshmukh, IAS';
      elements.userIdDisplay.textContent = 'MH-STATE-SYSADMIN-01';
      elements.userAvatar.textContent = 'AD';
      navigateToScreen('screen-admin-dept-mgmt');
      showToast('Switched to Maharashtra Interoperability System Admin');
    }
  }

  // Screen Rendering Registry
  function renderScreen(screenId) {
    switch (screenId) {
      case 'screen-citizen-dashboard':
        renderCitizenDashboard();
        break;
      case 'screen-my-profile':
        renderProfileScreen();
        break;
      case 'screen-consent-mgmt':
        renderConsentScreen();
        break;
      case 'screen-live-sync':
        renderLiveSyncScreen();
        break;
      case 'screen-service-catalog':
        renderServiceCatalog();
        break;
      case 'screen-service-details':
        renderServiceDetails(AppState.wizard.selectedServiceId);
        break;
      case 'screen-service-wizard':
        renderApplicationWizard();
        break;
      case 'screen-docs-vault':
        renderDocsVault();
        break;
      case 'screen-status-tracker':
        renderStatusTracker('APP-2024-MH-9811');
        break;
      case 'screen-app-history':
        renderApplicationHistory();
        break;
      case 'screen-notifications':
        renderNotificationsScreen();
        break;
      case 'screen-sync-audit':
        renderSyncAuditLedger();
        break;
      case 'screen-officer-dashboard':
        renderOfficerDashboard();
        break;
      case 'screen-officer-review':
        renderOfficerReview('APP-2024-MH-9811');
        break;
      case 'screen-admin-dept-mgmt':
        renderAdminDeptMgmt();
        break;
      case 'screen-admin-form-builder':
        renderAdminFormBuilder();
        break;
      case 'screen-admin-rule-builder':
        renderAdminRuleBuilder();
        break;
      case 'screen-admin-analytics':
        renderAdminAnalytics();
        break;
      case 'screen-demo-tour':
        renderDemoTour();
        break;
    }
  }

  /* --------------------------------------------------------------------------
     SCREEN 2: CITIZEN DASHBOARD
     -------------------------------------------------------------------------- */
  function renderCitizenDashboard() {
    const container = document.getElementById('dash-recent-apps-container');
    if (!container) return;

    container.innerHTML = AppState.applications.map(app => `
      <div class="gov-card" style="margin-bottom: 1rem; border-left: 4px solid var(--gov-primary);">
        <div style="display: flex; justify-content: space-between; align-items: flex-start;">
          <div>
            <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 4px;">
              <span class="badge ${getStatusBadgeClass(app.status)}">${app.status}</span>
              <span style="font-family: var(--font-mono); font-size: 0.75rem; color: var(--text-muted);">${app.id}</span>
            </div>
            <h4 style="font-size: 1rem; font-weight: 700; color: var(--gov-primary-dark);">${app.serviceName}</h4>
            <p style="font-size: 0.8rem; color: var(--text-muted); margin-top: 2px;">Dept: ${app.department} • Applied: ${app.submissionDate}</p>
          </div>
          <div style="text-align: right;">
            <div style="font-size: 0.82rem; font-weight: 700; color: var(--text-primary); margin-bottom: 6px;">Next: ${app.currentStep}</div>
            <button class="btn btn-outline-primary btn-sm" onclick="App.trackApplication('${app.id}')">
              Track Status ➔
            </button>
          </div>
        </div>
      </div>
    `).join('');
  }

  function getStatusBadgeClass(status) {
    switch (status) {
      case 'Approved':
      case 'Verified':
        return 'badge-success';
      case 'In Scrutiny':
      case 'Pending Verification':
        return 'badge-warning';
      case 'Rejected':
        return 'badge-danger';
      default:
        return 'badge-info';
    }
  }

  /* --------------------------------------------------------------------------
     SCREEN 3 & 4: PROFILE & UPDATE
     -------------------------------------------------------------------------- */
  function renderProfileScreen() {
    const p = AppState.citizen;
    const view = document.getElementById('profile-fields-grid');
    if (!view) return;

    view.innerHTML = `
      <div class="form-group">
        <label class="form-label">Full Name (UIDAI Verified)</label>
        <input class="form-input" value="${p.name}" readonly style="background: #F1F5F9; font-weight: 600;">
      </div>
      <div class="form-group">
        <label class="form-label">Citizen ID</label>
        <input class="form-input" value="${p.citizenId}" readonly style="background: #F1F5F9; font-family: var(--font-mono);">
      </div>
      <div class="form-group">
        <label class="form-label">Aadhaar (Masked)</label>
        <input class="form-input" value="${p.aadhaarMasked}" readonly style="background: #F1F5F9; font-family: var(--font-mono);">
      </div>
      <div class="form-group">
        <label class="form-label">PAN Number</label>
        <input class="form-input" value="${p.panMasked}" readonly style="background: #F1F5F9; font-family: var(--font-mono);">
      </div>
      <div class="form-group">
        <label class="form-label">Mobile Number</label>
        <input class="form-input" id="profile-edit-phone" value="${p.phone}">
      </div>
      <div class="form-group">
        <label class="form-label">Email Address</label>
        <input class="form-input" id="profile-edit-email" value="${p.email}">
      </div>
      <div class="form-group" style="grid-column: span 2;">
        <label class="form-label">Residential Address (Revenue Sync)</label>
        <input class="form-input" id="profile-edit-address" value="${p.address}">
      </div>
      <div class="form-group">
        <label class="form-label">District / Taluka</label>
        <input class="form-input" value="${p.district} / ${p.taluka}" readonly style="background: #F1F5F9;">
      </div>
      <div class="form-group">
        <label class="form-label">Annual Family Income</label>
        <input class="form-input" value="₹ ${p.annualIncome.toLocaleString('en-IN')}" readonly style="background: #F1F5F9;">
      </div>
    `;
  }

  function saveProfileChanges() {
    const phone = document.getElementById('profile-edit-phone')?.value;
    const email = document.getElementById('profile-edit-email')?.value;
    const address = document.getElementById('profile-edit-address')?.value;

    if (phone) AppState.citizen.phone = phone;
    if (email) AppState.citizen.email = email;
    if (address) AppState.citizen.address = address;

    // Trigger synthetic sync event
    const newLog = {
      id: `LOG-2024-${Math.floor(1000 + Math.random() * 9000)}`,
      timestamp: new Date().toISOString().replace('T', ' ').substring(0, 19),
      sourceDept: 'Citizen Profile Portal',
      targetDept: 'Central Citizen Registry',
      action: 'Profile Details Update',
      status: 'Success',
      hash: 'sha256:b89fa710' + Math.random().toString(16).substring(2, 10)
    };
    AppState.syncLedger.unshift(newLog);

    showToast('Profile updated & synchronized with State Digital Vault!');
  }

  /* --------------------------------------------------------------------------
     SCREEN 5: DPDP CONSENT MANAGEMENT
     -------------------------------------------------------------------------- */
  function renderConsentScreen() {
    const list = document.getElementById('consents-list-container');
    if (!list) return;

    list.innerHTML = AppState.consents.map((c, idx) => `
      <div class="gov-card" style="margin-bottom: 1.25rem;">
        <div style="display: flex; justify-content: space-between; align-items: flex-start;">
          <div>
            <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 6px;">
              <span class="badge ${c.status === 'Active' ? 'badge-success' : 'badge-neutral'}">${c.status}</span>
              <h4 style="font-size: 1.05rem; font-weight: 700; color: var(--gov-primary-dark);">${c.serviceName}</h4>
            </div>
            <p style="font-size: 0.85rem; color: var(--text-secondary); margin-bottom: 8px;"><strong>Consumer Department:</strong> ${c.consumerDept}</p>
            <div style="display: flex; gap: 6px; flex-wrap: wrap; margin-bottom: 8px;">
              ${c.dataFields.map(f => `<span style="background: #F1F5F9; border: 1px solid #CBD5E1; padding: 2px 8px; border-radius: 4px; font-size: 0.75rem;">${f}</span>`).join('')}
            </div>
            <p style="font-size: 0.75rem; color: var(--text-muted);">Purpose: ${c.purpose} • Valid Until: ${c.expiry}</p>
          </div>
          <div style="display: flex; flex-direction: column; align-items: flex-end; gap: 8px;">
            <label style="position: relative; display: inline-block; width: 44px; height: 24px;">
              <input type="checkbox" ${c.status === 'Active' ? 'checked' : ''} onchange="App.toggleConsent(${idx}, this.checked)" style="opacity: 0; width: 0; height: 0;">
              <span style="position: absolute; cursor: pointer; top: 0; left: 0; right: 0; bottom: 0; background-color: ${c.status === 'Active' ? 'var(--gov-green)' : '#CBD5E1'}; transition: .3s; border-radius: 24px;"></span>
            </label>
            <span style="font-size: 0.72rem; color: var(--text-muted);">${c.status === 'Active' ? 'Consent Granted' : 'Revoked'}</span>
          </div>
        </div>
      </div>
    `).join('');
  }

  function toggleConsent(index, isActive) {
    AppState.consents[index].status = isActive ? 'Active' : 'Revoked';
    showToast(`Consent ${isActive ? 'granted to' : 'revoked from'} ${AppState.consents[index].consumerDept}`);
    renderConsentScreen();
  }

  /* --------------------------------------------------------------------------
     SCREEN 6: LIVE SYNCHRONIZATION DASHBOARD
     -------------------------------------------------------------------------- */
  function renderLiveSyncScreen() {
    const container = document.getElementById('live-sync-nodes-container');
    if (!container) return;

    container.innerHTML = AppState.departments.map(dept => `
      <div class="topology-node ${dept.id === 'DEPT-PMC-01' ? 'hub-node' : ''}">
        <div style="display: flex; align-items: center; justify-content: center;">
          <span class="node-status-dot ${dept.syncStatus === 'Synchronized' ? 'node-online' : 'node-syncing'}"></span>
          <span style="font-size: 0.75rem; font-weight: 700; color: #FFF;">${dept.syncStatus}</span>
        </div>
        <h4>${dept.name}</h4>
        <p>${dept.servicesCount} Active Services</p>
        <span class="node-latency">${dept.latencyMs} ms API ping</span>
      </div>
    `).join('');

    const recentSyncList = document.getElementById('live-sync-recent-events');
    if (recentSyncList) {
      recentSyncList.innerHTML = AppState.syncLedger.slice(0, 5).map(item => `
        <div style="padding: 10px; border-bottom: 1px solid var(--border-color); display: flex; justify-content: space-between; align-items: center;">
          <div>
            <span style="font-size: 0.78rem; font-weight: 700; color: var(--gov-primary);">${item.sourceDept} ➔ ${item.targetDept}</span>
            <p style="font-size: 0.75rem; color: var(--text-muted);">${item.action} • ${item.timestamp}</p>
          </div>
          <span class="badge badge-success">${item.status}</span>
        </div>
      `).join('');
    }
  }

  function triggerLiveInterDeptSync() {
    showToast('Initiating real-time API mesh health & hash exchange...', false);

    // Simulate multi-department latency and sync
    setTimeout(() => {
      AppState.departments.forEach(d => {
        d.syncStatus = 'Synchronized';
        d.lastSync = 'Just now';
        d.latencyMs = Math.floor(35 + Math.random() * 40);
      });

      const newLog = {
        id: `LOG-2024-${Math.floor(1000 + Math.random() * 9000)}`,
        timestamp: new Date().toISOString().replace('T', ' ').substring(0, 19),
        sourceDept: 'Government Interoperability Hub',
        targetDept: 'All 5 Department Registries',
        action: 'Manual Federated Health & Ledger Sync',
        status: 'Success',
        hash: 'sha256:fed9101' + Math.random().toString(16).substring(2, 10)
      };
      AppState.syncLedger.unshift(newLog);

      renderLiveSyncScreen();
      showToast('All 5 Department Registries Synchronized Successfully!');
    }, 1200);
  }

  /* --------------------------------------------------------------------------
     SCREEN 7 & 8: SERVICE CATALOG & DETAILS / AUTO-ELIGIBILITY
     -------------------------------------------------------------------------- */
  function renderServiceCatalog() {
    const grid = document.getElementById('services-cards-catalog');
    if (!grid) return;

    grid.innerHTML = AppState.services.map(srv => {
      const eligibility = evaluateEligibility(srv.id, AppState.citizen);
      return `
        <div class="service-card">
          <div>
            <div class="service-dept-tag">${srv.department}</div>
            <h3 class="service-title">${srv.title}</h3>
            <p class="service-desc">${srv.description}</p>
            
            <div class="eligibility-pill-badge ${eligibility.isEligible ? 'eligible' : 'not-eligible'}">
              ${eligibility.isEligible ? '✔ Auto-Eligible (Verified)' : '✖ Not Eligible'}
            </div>
            <p style="font-size: 0.72rem; color: var(--text-muted); margin-bottom: 1rem;">
              Rule check: ${eligibility.reason}
            </p>
          </div>
          
          <div class="service-card-footer">
            <span style="font-size: 0.75rem; font-weight: 600; color: var(--text-muted);">SLA: ${srv.slaDays} Days</span>
            <button class="btn btn-primary btn-sm" onclick="App.openServiceDetails('${srv.id}')">
              View & Apply ➔
            </button>
          </div>
        </div>
      `;
    }).join('');
  }

  // Dynamic Rule Evaluation Engine
  function evaluateEligibility(serviceId, citizen) {
    if (serviceId === 'SRV-AGRI-001') {
      // Shetkari Samman Yojana
      const ownsLand = citizen.landHoldingsAcres > 0;
      const incomeOk = citizen.annualIncome <= 250000;
      if (ownsLand && incomeOk) {
        return { isEligible: true, reason: `Landholding (${citizen.landHoldingsAcres} Ac) & Income (₹${citizen.annualIncome}) meet criteria` };
      } else {
        return { isEligible: false, reason: `Landholding or Income criteria not satisfied` };
      }
    } else if (serviceId === 'SRV-PMC-001') {
      // PMC Water Connection
      const isPune = citizen.district.toLowerCase().includes('pune');
      return { isEligible: isPune, reason: isPune ? 'Resident of Pune Municipal limits' : 'Must reside in Pune' };
    } else if (serviceId === 'SRV-REV-001') {
      // Non-Creamy Layer
      const incomeOk = citizen.annualIncome < 800000;
      return { isEligible: incomeOk, reason: incomeOk ? `Annual income below ₹8.00 Lakh cap` : `Income exceeds ₹8.00 Lakh cap` };
    } else if (serviceId === 'SRV-LAND-001') {
      // 7/12 Land Extract
      const ownsLand = citizen.landHoldingsAcres > 0;
      return { isEligible: ownsLand, reason: ownsLand ? 'Land parcel linked with Aadhaar in MahaBhumi' : 'No linked landholding' };
    }
    return { isEligible: true, reason: 'Basic Maharashtra Domicile verified' };
  }

  function openServiceDetails(serviceId) {
    AppState.wizard.selectedServiceId = serviceId;
    navigateToScreen('screen-service-details');
  }

  function renderServiceDetails(serviceId) {
    const srv = AppState.services.find(s => s.id === serviceId) || AppState.services[0];
    const eligibility = evaluateEligibility(srv.id, AppState.citizen);

    const titleEl = document.getElementById('details-srv-title');
    const deptEl = document.getElementById('details-srv-dept');
    const descEl = document.getElementById('details-srv-desc');
    const badgeEl = document.getElementById('details-srv-eligibility-badge');
    const ruleDetailEl = document.getElementById('details-srv-rule-result');

    if (titleEl) titleEl.textContent = srv.title;
    if (deptEl) deptEl.textContent = srv.department;
    if (descEl) descEl.textContent = srv.description;
    
    if (badgeEl) {
      badgeEl.className = `eligibility-pill-badge ${eligibility.isEligible ? 'eligible' : 'not-eligible'}`;
      badgeEl.textContent = eligibility.isEligible ? '✔ You are Auto-Eligible based on synchronized records' : '✖ Currently Ineligible';
    }

    if (ruleDetailEl) {
      ruleDetailEl.innerHTML = `
        <div style="background: #F8FAFC; border: 1px solid var(--border-color); border-radius: var(--radius-md); padding: 1rem; margin-top: 1rem;">
          <h4 style="font-size: 0.9rem; font-weight: 700; color: var(--gov-primary);">System Auto-Check Verification</h4>
          <p style="font-size: 0.85rem; color: var(--text-secondary); margin-top: 4px;">${eligibility.reason}</p>
          <div style="margin-top: 10px; font-size: 0.75rem; color: var(--text-muted); font-family: var(--font-mono);">
            Checked across: Revenue Registry • DigiLocker UIDAI • MahaBhumi Bhulekh
          </div>
        </div>
      `;
    }
  }

  /* --------------------------------------------------------------------------
     SCREEN 9: DYNAMIC SERVICE APPLICATION WIZARD
     -------------------------------------------------------------------------- */
  function startApplicationWizard(serviceId) {
    if (serviceId) AppState.wizard.selectedServiceId = serviceId;
    AppState.wizard.currentStep = 1;
    navigateToScreen('screen-service-wizard');
  }

  function renderApplicationWizard() {
    const srv = AppState.services.find(s => s.id === AppState.wizard.selectedServiceId) || AppState.services[0];
    const srvTitleEl = document.getElementById('wizard-service-title');
    if (srvTitleEl) srvTitleEl.textContent = `${srv.title} (${srv.department})`;

    // Update wizard steps visual
    document.querySelectorAll('.wizard-step-node').forEach((node, idx) => {
      const stepNumber = idx + 1;
      node.classList.remove('active', 'completed');
      if (stepNumber < AppState.wizard.currentStep) node.classList.add('completed');
      if (stepNumber === AppState.wizard.currentStep) node.classList.add('active');
    });

    // Render Step Content
    const stepContent = document.getElementById('wizard-step-content');
    if (!stepContent) return;

    if (AppState.wizard.currentStep === 1) {
      stepContent.innerHTML = `
        <div class="gov-card highlight-blue">
          <div class="card-header-clean">
            <h3 class="card-title">Step 1: Citizen Profile (Consolidated From National & State Registries)</h3>
            <span class="badge badge-success">Pre-Filled From Central Vault</span>
          </div>
          <p style="font-size: 0.85rem; color: var(--text-muted); margin-bottom: 1.25rem;">
            Notice: You do not need to re-enter your basic demographic details. They are already securely verified.
          </p>
          <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 1.25rem;">
            <div class="form-group prefilled-field-wrapper">
              <span class="prefilled-badge">Aadhaar Verified</span>
              <label class="form-label">Full Name</label>
              <input class="form-input" value="${AppState.citizen.name}" readonly style="background: #F8FAFC;">
            </div>
            <div class="form-group prefilled-field-wrapper">
              <span class="prefilled-badge">MahaGov Citizen ID</span>
              <label class="form-label">Citizen Reference ID</label>
              <input class="form-input" value="${AppState.citizen.citizenId}" readonly style="background: #F8FAFC;">
            </div>
            <div class="form-group prefilled-field-wrapper">
              <span class="prefilled-badge">UIDAI Masked</span>
              <label class="form-label">Aadhaar Number</label>
              <input class="form-input" value="${AppState.citizen.aadhaarMasked}" readonly style="background: #F8FAFC;">
            </div>
            <div class="form-group prefilled-field-wrapper">
              <span class="prefilled-badge">ITD PAN</span>
              <label class="form-label">PAN Number</label>
              <input class="form-input" value="${AppState.citizen.panMasked}" readonly style="background: #F8FAFC;">
            </div>
          </div>
        </div>
      `;
    } else if (AppState.wizard.currentStep === 2) {
      // Dynamic fields loaded from service schema config
      const dynamicFields = portalData.serviceFieldConfigs[srv.id] || portalData.serviceFieldConfigs['SRV-AGRI-001'];
      stepContent.innerHTML = `
        <div class="gov-card highlight-saffron">
          <div class="card-header-clean">
            <h3 class="card-title">Step 2: Department-Specific Dynamic Form Fields</h3>
            <span class="badge badge-info">Zero-Code Schema Form</span>
          </div>
          <p style="font-size: 0.85rem; color: var(--text-muted); margin-bottom: 1.25rem;">
            These fields are dynamically loaded from ${srv.department}'s registered API schema.
          </p>
          <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 1.25rem;">
            ${dynamicFields.map(field => `
              <div class="form-group" style="${field.type === 'textarea' ? 'grid-column: span 2;' : ''}">
                <label class="form-label">${field.label} ${field.required ? '<span style="color:red">*</span>' : ''}</label>
                ${renderFieldControl(field)}
              </div>
            `).join('')}
          </div>
        </div>
      `;
    } else if (AppState.wizard.currentStep === 3) {
      stepContent.innerHTML = `
        <div class="gov-card highlight-green">
          <div class="card-header-clean">
            <h3 class="card-title">Step 3: Document Attachments (DigiLocker Re-Use)</h3>
            <span class="badge badge-success">Zero Physical Uploads</span>
          </div>
          <p style="font-size: 0.85rem; color: var(--text-muted); margin-bottom: 1.25rem;">
            Documents required for this service have been automatically linked from your DigiLocker vault.
          </p>
          <div style="display: flex; flex-direction: column; gap: 1rem;">
            ${AppState.documents.map(doc => `
              <div style="display: flex; align-items: center; justify-content: space-between; padding: 12px 16px; border: 1px solid var(--border-color); border-radius: var(--radius-md); background: #FFF;">
                <div style="display: flex; align-items: center; gap: 12px;">
                  <span style="font-size: 1.5rem;">📄</span>
                  <div>
                    <h5 style="font-size: 0.9rem; font-weight: 700;">${doc.docType}</h5>
                    <span style="font-size: 0.72rem; color: var(--text-muted); font-family: var(--font-mono);">${doc.id} • Issued by ${doc.issuer}</span>
                  </div>
                </div>
                <div style="display: flex; align-items: center; gap: 8px;">
                  <span class="badge badge-success">✔ Verified by DigiLocker</span>
                  <input type="checkbox" checked style="width: 18px; height: 18px;">
                </div>
              </div>
            `).join('')}
          </div>
        </div>
      `;
    } else if (AppState.wizard.currentStep === 4) {
      stepContent.innerHTML = `
        <div class="gov-card highlight-blue">
          <div class="card-header-clean">
            <h3 class="card-title">Step 4: DPDP Act Consent Declaration & Final Submission</h3>
            <span class="badge badge-warning">Digital Personal Data Protection Act 2023</span>
          </div>
          <div style="background: #F8FAFC; border: 1px solid var(--border-color); border-radius: var(--radius-md); padding: 1.25rem; margin-bottom: 1.5rem;">
            <h4 style="font-size: 0.95rem; font-weight: 700; color: var(--gov-primary);">Consent and Authorization Clause</h4>
            <p style="font-size: 0.82rem; color: var(--text-secondary); line-height: 1.5; margin-top: 6px;">
              I, <strong>${AppState.citizen.name}</strong>, hereby authorize the Government Interoperability Hub to securely transmit my Aadhaar, Land Holdings, and Bank details to <strong>${srv.department}</strong> solely for processing the application for <strong>${srv.title}</strong> in accordance with the Digital Personal Data Protection Act, 2023.
            </p>
            <div style="margin-top: 12px; display: flex; align-items: center; gap: 10px;">
              <input type="checkbox" id="wizard-consent-checkbox" checked style="width: 20px; height: 20px;">
              <label for="wizard-consent-checkbox" style="font-size: 0.85rem; font-weight: 700; color: var(--text-primary); cursor: pointer;">
                I agree to the electronic data-sharing terms and authenticate via Aadhaar E-Sign.
              </label>
            </div>
          </div>
          
          <div style="background: #FEF3C7; border: 1px solid #FDE68A; border-radius: var(--radius-md); padding: 12px; font-size: 0.8rem; color: #92400E; display: flex; align-items: center; gap: 8px;">
            <span>ℹ</span>
            <span><strong>Simulated Department API Integration:</strong> Upon clicking submit, a simulated payload will be dispatched to the department verification queue.</span>
          </div>
        </div>
      `;
    }

    // Step Nav Buttons
    const backBtn = document.getElementById('wizard-prev-btn');
    const nextBtn = document.getElementById('wizard-next-btn');

    if (backBtn) {
      backBtn.style.display = AppState.wizard.currentStep === 1 ? 'none' : 'inline-flex';
      backBtn.onclick = () => {
        if (AppState.wizard.currentStep > 1) {
          AppState.wizard.currentStep--;
          renderApplicationWizard();
        }
      };
    }

    if (nextBtn) {
      if (AppState.wizard.currentStep === 4) {
        nextBtn.textContent = 'Submit Application (Simulated API) ✔';
        nextBtn.className = 'btn btn-green';
        nextBtn.onclick = submitApplication;
      } else {
        nextBtn.textContent = 'Continue to Next Step ➔';
        nextBtn.className = 'btn btn-primary';
        nextBtn.onclick = () => {
          AppState.wizard.currentStep++;
          renderApplicationWizard();
        };
      }
    }
  }

  function renderFieldControl(field) {
    if (field.type === 'select') {
      return `
        <select class="form-select">
          ${field.options.map(opt => `<option>${opt}</option>`).join('')}
        </select>
      `;
    } else if (field.type === 'number') {
      return `<input type="number" class="form-input" placeholder="e.g. 15000">`;
    } else if (field.type === 'textarea') {
      return `<textarea class="form-textarea" rows="3" placeholder="Provide details..."></textarea>`;
    }
    return `<input type="text" class="form-input" placeholder="Enter ${field.label}">`;
  }

  function submitApplication() {
    const srv = AppState.services.find(s => s.id === AppState.wizard.selectedServiceId) || AppState.services[0];
    const newAppId = `APP-2024-MH-${Math.floor(1000 + Math.random() * 9000)}`;

    const newApp = {
      id: newAppId,
      serviceId: srv.id,
      serviceName: srv.title,
      department: srv.department,
      applicantName: AppState.citizen.name,
      citizenId: AppState.citizen.citizenId,
      submissionDate: new Date().toISOString().substring(0, 10),
      status: 'In Scrutiny',
      currentStep: 'Desk Officer Verification',
      slaRemainingDays: srv.slaDays,
      timeline: [
        { title: 'Application Submitted via Interoperability Hub', date: new Date().toISOString().substring(0, 10), status: 'completed', desc: 'Auto-verified with UIDAI and DigiLocker vaults.' },
        { title: 'Dispatched to Department Scrutiny Desk', date: new Date().toISOString().substring(0, 10), status: 'current', desc: 'Simulated API packet handed off to Desk Officer queue.' },
        { title: 'Field Inspection / Document Check', date: 'Pending', status: 'pending', desc: 'Desk Officer to review land records & eligibility.' },
        { title: 'Sanction Order & DBT Disbursement', date: 'Pending', status: 'pending', desc: 'Direct Benefit Transfer into Aadhaar-seeded account.' }
      ]
    };

    AppState.applications.unshift(newApp);

    // Also add to audit ledger
    AppState.syncLedger.unshift({
      id: `LOG-2024-${Math.floor(1000 + Math.random() * 9000)}`,
      timestamp: new Date().toISOString().replace('T', ' ').substring(0, 19),
      sourceDept: 'Interoperability Hub (Citizen Portal)',
      targetDept: srv.department,
      action: `Application Handoff [${newAppId}]`,
      status: 'Success',
      hash: 'sha256:app' + Math.random().toString(16).substring(2, 10)
    });

    showToast(`Application ${newAppId} Dispatched Successfully!`);
    trackApplication(newAppId);
  }

  /* --------------------------------------------------------------------------
     SCREEN 10: DIGILOCKER VAULT
     -------------------------------------------------------------------------- */
  function renderDocsVault() {
    const container = document.getElementById('docs-vault-cards-grid');
    if (!container) return;

    container.innerHTML = AppState.documents.map(doc => `
      <div class="doc-card">
        <div>
          <div style="display: flex; justify-content: space-between; align-items: center;">
            <span style="font-size: 1.75rem;">📜</span>
            <span class="doc-badge-verified">✔ DigiLocker Verified</span>
          </div>
          <h4 style="font-size: 1.05rem; font-weight: 700; color: var(--gov-primary-dark); margin-top: 10px;">${doc.docType}</h4>
          <p class="doc-metadata">Doc ID: ${doc.id}<br>Issuer: ${doc.issuer}<br>Issued Date: ${doc.issuedDate}</p>
        </div>
        <div style="display: flex; gap: 8px; margin-top: 1rem;">
          <button class="btn btn-secondary btn-sm" style="flex: 1;" onclick="App.previewDocModal('${doc.id}')">View Proof</button>
          <button class="btn btn-outline-primary btn-sm" onclick="App.showToast('Secure download link generated')">Download</button>
        </div>
      </div>
    `).join('');
  }

  function previewDocModal(docId) {
    const doc = AppState.documents.find(d => d.id === docId) || AppState.documents[0];
    showModal(`Digital Document: ${doc.docType}`, `
      <div style="padding: 1rem; background: #F8FAFC; border-radius: var(--radius-md); border: 1px solid var(--border-color); font-family: var(--font-mono); font-size: 0.85rem;">
        <p><strong>Document ID:</strong> ${doc.id}</p>
        <p><strong>Issuing Authority:</strong> ${doc.issuer}</p>
        <p><strong>Beneficiary:</strong> ${AppState.citizen.name}</p>
        <p><strong>Digital Signature:</strong> Verified by Government of Maharashtra PKI Certificate Authority</p>
        <p><strong>SHA-256 Checksum:</strong> ${doc.hash}</p>
        <div style="margin-top: 1rem; height: 160px; background: #FFF; border: 1px dashed #CBD5E1; display: flex; align-items: center; justify-content: center; color: var(--text-muted);">
          [Official Government Digital Seal & QR Code Embedded]
        </div>
      </div>
    `);
  }

  /* --------------------------------------------------------------------------
     SCREEN 11: STATUS TRACKER & TIMELINE
     -------------------------------------------------------------------------- */
  function trackApplication(appId) {
    const app = AppState.applications.find(a => a.id === appId) || AppState.applications[0];
    navigateToScreen('screen-status-tracker');
    renderStatusTracker(app.id);
  }

  function renderStatusTracker(appId) {
    const app = AppState.applications.find(a => a.id === appId) || AppState.applications[0];
    const headerEl = document.getElementById('tracker-app-header');
    const timelineEl = document.getElementById('tracker-timeline-box');

    if (headerEl) {
      headerEl.innerHTML = `
        <div>
          <span style="font-family: var(--font-mono); font-size: 0.8rem; color: var(--text-muted);">${app.id}</span>
          <h2 style="font-size: 1.3rem; font-weight: 800; color: var(--gov-primary-dark);">${app.serviceName}</h2>
          <p style="font-size: 0.85rem; color: var(--text-secondary);">Department: ${app.department} • Applied: ${app.submissionDate}</p>
        </div>
        <div style="text-align: right;">
          <span class="badge ${getStatusBadgeClass(app.status)}" style="font-size: 0.85rem; padding: 6px 14px;">${app.status}</span>
          <p style="font-size: 0.75rem; color: var(--text-muted); margin-top: 4px;">SLA Remaining: ${app.slaRemainingDays} Days</p>
        </div>
      `;
    }

    if (timelineEl) {
      timelineEl.innerHTML = app.timeline.map(event => `
        <div class="timeline-event ${event.status}">
          <div class="timeline-event-marker"></div>
          <div class="timeline-event-title">${event.title}</div>
          <div class="timeline-event-date">${event.date}</div>
          <div class="timeline-event-desc">${event.desc}</div>
        </div>
      `).join('');
    }
  }

  /* --------------------------------------------------------------------------
     SCREEN 12 & 13: APPLICATION HISTORY & NOTIFICATIONS
     -------------------------------------------------------------------------- */
  function renderApplicationHistory() {
    const tbody = document.getElementById('app-history-tbody');
    if (!tbody) return;

    tbody.innerHTML = AppState.applications.map(app => `
      <tr>
        <td style="font-family: var(--font-mono); font-weight: 700;">${app.id}</td>
        <td><strong>${app.serviceName}</strong></td>
        <td>${app.department}</td>
        <td>${app.submissionDate}</td>
        <td><span class="badge ${getStatusBadgeClass(app.status)}">${app.status}</span></td>
        <td>
          <button class="btn btn-outline-primary btn-sm" onclick="App.trackApplication('${app.id}')">Track</button>
        </td>
      </tr>
    `).join('');
  }

  function renderNotificationsScreen() {
    const list = document.getElementById('notifications-list-container');
    if (!list) return;

    list.innerHTML = AppState.notifications.map(n => `
      <div class="gov-card" style="margin-bottom: 1rem; border-left: 4px solid ${n.unread ? 'var(--gov-saffron)' : 'var(--border-color)'};">
        <div style="display: flex; justify-content: space-between; align-items: flex-start;">
          <div>
            <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 4px;">
              ${n.unread ? '<span class="badge badge-warning">New</span>' : ''}
              <h4 style="font-size: 0.95rem; font-weight: 700;">${n.title}</h4>
            </div>
            <p style="font-size: 0.85rem; color: var(--text-secondary);">${n.message}</p>
            <span style="font-size: 0.72rem; color: var(--text-muted); margin-top: 6px; display: block;">${n.timestamp}</span>
          </div>
          <button class="btn btn-secondary btn-sm" onclick="App.showToast('Notification acknowledged')">Dismiss</button>
        </div>
      </div>
    `).join('');
  }

  /* --------------------------------------------------------------------------
     SCREEN 14: AUDIT LEDGER / SYNC LOG
     -------------------------------------------------------------------------- */
  function renderSyncAuditLedger() {
    const tbody = document.getElementById('audit-ledger-tbody');
    if (!tbody) return;

    tbody.innerHTML = AppState.syncLedger.map(log => `
      <tr>
        <td style="font-family: var(--font-mono); font-weight: 700;">${log.id}</td>
        <td style="white-space: nowrap;">${log.timestamp}</td>
        <td><strong>${log.sourceDept}</strong></td>
        <td><strong>${log.targetDept}</strong></td>
        <td>${log.action}</td>
        <td><span class="badge badge-success">${log.status}</span></td>
        <td class="hash-cell">${log.hash}</td>
      </tr>
    `).join('');
  }

  /* --------------------------------------------------------------------------
     SCREEN 16 & 17: DEPARTMENT ADMIN DASHBOARD & APPLICATION REVIEW
     -------------------------------------------------------------------------- */
  function renderOfficerDashboard() {
    const tbody = document.getElementById('officer-queue-tbody');
    if (!tbody) return;

    tbody.innerHTML = AppState.applications.map(app => `
      <tr>
        <td style="font-family: var(--font-mono); font-weight: 700;">${app.id}</td>
        <td><strong>${app.applicantName}</strong><br><span style="font-size: 0.72rem; color: var(--text-muted); font-family: var(--font-mono);">${app.citizenId}</span></td>
        <td>${app.serviceName}</td>
        <td>${app.submissionDate}</td>
        <td><span class="badge ${getStatusBadgeClass(app.status)}">${app.status}</span></td>
        <td><span class="badge badge-neutral">${app.slaRemainingDays} Days left</span></td>
        <td>
          <button class="btn btn-primary btn-sm" onclick="App.openOfficerReview('${app.id}')">Scrutinize ➔</button>
        </td>
      </tr>
    `).join('');
  }

  function openOfficerReview(appId) {
    navigateToScreen('screen-officer-review');
    renderOfficerReview(appId);
  }

  function renderOfficerReview(appId) {
    const app = AppState.applications.find(a => a.id === appId) || AppState.applications[0];
    const container = document.getElementById('officer-review-content');
    if (!container) return;

    container.innerHTML = `
      <div class="gov-card highlight-saffron" style="margin-bottom: 1.5rem;">
        <div class="card-header-clean">
          <div>
            <span style="font-family: var(--font-mono); font-size: 0.78rem; color: var(--text-muted);">${app.id}</span>
            <h2 style="font-size: 1.3rem; font-weight: 800; color: var(--gov-primary-dark);">${app.serviceName}</h2>
            <p style="font-size: 0.85rem; color: var(--text-secondary);">Applicant: ${app.applicantName} (${app.citizenId})</p>
          </div>
          <span class="badge ${getStatusBadgeClass(app.status)}" style="font-size: 0.9rem; padding: 6px 14px;">${app.status}</span>
        </div>

        <h4 style="font-size: 0.95rem; font-weight: 700; color: var(--gov-primary); margin-bottom: 0.75rem;">Cross-Department Data Feeds (Pre-Validated)</h4>
        <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 1rem; margin-bottom: 1.5rem;">
          <div style="background: #F8FAFC; border: 1px solid var(--border-color); border-radius: var(--radius-md); padding: 12px;">
            <span class="badge badge-success" style="margin-bottom: 6px;">UIDAI Verified</span>
            <p style="font-size: 0.82rem; font-weight: 700;">Aadhaar Proof</p>
            <p style="font-size: 0.75rem; color: var(--text-muted); font-family: var(--font-mono);">${AppState.citizen.aadhaarMasked}</p>
          </div>
          <div style="background: #F8FAFC; border: 1px solid var(--border-color); border-radius: var(--radius-md); padding: 12px;">
            <span class="badge badge-success" style="margin-bottom: 6px;">MahaBhumi Verified</span>
            <p style="font-size: 0.82rem; font-weight: 700;">Land Holding</p>
            <p style="font-size: 0.75rem; color: var(--text-muted); font-family: var(--font-mono);">${AppState.citizen.landHoldingsAcres} Acres (Haveli Taluka)</p>
          </div>
          <div style="background: #F8FAFC; border: 1px solid var(--border-color); border-radius: var(--radius-md); padding: 12px;">
            <span class="badge badge-success" style="margin-bottom: 6px;">Revenue Dept Verified</span>
            <p style="font-size: 0.82rem; font-weight: 700;">Income Proof</p>
            <p style="font-size: 0.75rem; color: var(--text-muted); font-family: var(--font-mono);">₹ ${AppState.citizen.annualIncome} p.a.</p>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label">Desk Officer Scrutiny Remarks</label>
          <textarea id="officer-remarks-input" class="form-textarea" rows="3" placeholder="Enter scrutiny notes or reason for approval / objection..."></textarea>
        </div>

        <div style="display: flex; gap: 1rem; justify-content: flex-end; padding-top: 1rem; border-top: 1px solid var(--border-color);">
          <button class="btn btn-secondary" onclick="App.officerAction('${app.id}', 'Request Info')">Request More Info</button>
          <button class="btn btn-danger" onclick="App.officerAction('${app.id}', 'Reject')">Reject Application</button>
          <button class="btn btn-green" onclick="App.officerAction('${app.id}', 'Approve')">Approve & Grant Sanction ✔</button>
        </div>
      </div>
    `;
  }

  function officerAction(appId, action) {
    const app = AppState.applications.find(a => a.id === appId);
    const remarks = document.getElementById('officer-remarks-input')?.value || 'Standard verification criteria satisfied.';

    if (action === 'Approve') {
      app.status = 'Approved';
      app.currentStep = 'Sanction Order Generated & DBT Dispatched';
      app.timeline.push({
        title: 'Approved by Desk Officer',
        date: new Date().toISOString().substring(0, 10),
        status: 'completed',
        desc: `Sanction granted with remarks: ${remarks}`
      });
      showToast(`Application ${appId} Approved! Sanction Order Generated.`);
    } else if (action === 'Reject') {
      app.status = 'Rejected';
      app.currentStep = 'Rejected by Scrutiny Desk';
      app.timeline.push({
        title: 'Application Rejected',
        date: new Date().toISOString().substring(0, 10),
        status: 'completed',
        desc: `Objection reason: ${remarks}`
      });
      showToast(`Application ${appId} Marked as Rejected.`, false);
    } else {
      app.status = 'Pending Verification';
      app.currentStep = 'Additional Documentation Requested';
      showToast(`Clarification requested from citizen for ${appId}`);
    }

    // Refresh review view and return to dashboard
    renderOfficerDashboard();
    navigateToScreen('screen-officer-dashboard');
  }

  /* --------------------------------------------------------------------------
     SCREEN 18: SYSTEM ADMIN DEPARTMENT / SERVICE MANAGEMENT
     -------------------------------------------------------------------------- */
  function renderAdminDeptMgmt() {
    const grid = document.getElementById('admin-dept-cards-grid');
    if (!grid) return;

    grid.innerHTML = AppState.departments.map(dept => `
      <div class="gov-card">
        <div style="display: flex; justify-content: space-between; align-items: flex-start;">
          <div>
            <span style="font-family: var(--font-mono); font-size: 0.72rem; color: var(--text-muted);">${dept.id}</span>
            <h4 style="font-size: 1.1rem; font-weight: 700; color: var(--gov-primary-dark);">${dept.name}</h4>
            <p style="font-size: 0.8rem; color: var(--text-secondary); margin-top: 4px;">Node Endpoint: <span style="font-family: var(--font-mono); font-size: 0.75rem;">${dept.apiEndpoint}</span></p>
          </div>
          <span class="badge ${dept.syncStatus === 'Synchronized' ? 'badge-success' : 'badge-warning'}">${dept.syncStatus}</span>
        </div>
        <div style="display: flex; gap: 1rem; margin-top: 1rem; font-size: 0.82rem; color: var(--text-muted);">
          <span>Services: <strong>${dept.servicesCount}</strong></span>
          <span>Latency: <strong>${dept.latencyMs}ms</strong></span>
          <span>Last Sync: <strong>${dept.lastSync}</strong></span>
        </div>
        <div style="display: flex; gap: 8px; margin-top: 1rem; padding-top: 0.75rem; border-top: 1px solid var(--border-color);">
          <button class="btn btn-outline-primary btn-sm" onclick="App.showToast('Testing API gateway ping for ${dept.name}...')">Test Health</button>
          <button class="btn btn-secondary btn-sm" onclick="App.navigateToScreen('screen-admin-form-builder')">Config Schema</button>
        </div>
      </div>
    `).join('');
  }

  /* --------------------------------------------------------------------------
     SCREEN 19: DYNAMIC FORM BUILDER WITH LIVE PREVIEW
     -------------------------------------------------------------------------- */
  function renderAdminFormBuilder() {
    const fieldsContainer = document.getElementById('builder-fields-list');
    const previewContainer = document.getElementById('builder-live-preview');
    if (!fieldsContainer || !previewContainer) return;

    const currentFields = portalData.serviceFieldConfigs['SRV-AGRI-001'];

    fieldsContainer.innerHTML = currentFields.map((f, idx) => `
      <div style="padding: 10px; border: 1px solid var(--border-color); border-radius: var(--radius-md); margin-bottom: 8px; background: #FFF; display: flex; justify-content: space-between; align-items: center;">
        <div>
          <strong style="font-size: 0.88rem;">${f.label}</strong>
          <span style="font-size: 0.72rem; color: var(--text-muted); font-family: var(--font-mono); margin-left: 8px;">(${f.id} : ${f.type})</span>
        </div>
        <button class="btn btn-sm btn-secondary" onclick="App.removeBuilderField(${idx})">✕</button>
      </div>
    `).join('');

    previewContainer.innerHTML = `
      <h4 style="font-size: 0.95rem; font-weight: 700; color: var(--gov-primary); margin-bottom: 1rem;">Live Citizen Form Rendering</h4>
      <div style="display: flex; flex-direction: column; gap: 12px;">
        ${currentFields.map(f => `
          <div>
            <label class="form-label">${f.label} ${f.required ? '<span style="color:red">*</span>' : ''}</label>
            ${renderFieldControl(f)}
          </div>
        `).join('')}
      </div>
    `;
  }

  function addBuilderField() {
    const nameInput = document.getElementById('new-field-label');
    const typeInput = document.getElementById('new-field-type');
    if (!nameInput || !nameInput.value.trim()) {
      showToast('Please enter a field label', false);
      return;
    }

    portalData.serviceFieldConfigs['SRV-AGRI-001'].push({
      id: `field_${Date.now().toString().slice(-4)}`,
      label: nameInput.value.trim(),
      type: typeInput.value,
      required: true
    });

    nameInput.value = '';
    renderAdminFormBuilder();
    showToast('Dynamic field added to schema!');
  }

  function removeBuilderField(index) {
    portalData.serviceFieldConfigs['SRV-AGRI-001'].splice(index, 1);
    renderAdminFormBuilder();
    showToast('Field removed from schema.');
  }

  /* --------------------------------------------------------------------------
     SCREEN 20: ELIGIBILITY RULE BUILDER & SANDBOX
     -------------------------------------------------------------------------- */
  function renderAdminRuleBuilder() {
    const consoleEl = document.getElementById('rule-sandbox-output');
    if (consoleEl) {
      consoleEl.innerHTML = `
        > Loading Rule Engine v2.4 (Interoperability Hub Kernel)...<br>
        > Current Policy: MH-RULE-AGRI-01 (Shetkari Samman Scheme)<br>
        > Parameter 1: landHoldingsAcres > 0 (Verified by MahaBhumi)<br>
        > Parameter 2: annualIncome <= 250000 (Verified by Revenue)<br>
        > Ready for live sandbox evaluation.
      `;
    }
  }

  function testRuleSandbox() {
    const landInput = parseFloat(document.getElementById('sandbox-test-land')?.value || '2.5');
    const incomeInput = parseFloat(document.getElementById('sandbox-test-income')?.value || '180000');
    const consoleEl = document.getElementById('rule-sandbox-output');

    const isEligible = landInput > 0 && incomeInput <= 250000;

    if (consoleEl) {
      consoleEl.innerHTML += `<br><br>
        <span style="color: #FCD34D;">[TEST EVALUATION]</span><br>
        • Input Landholding: ${landInput} Acres (MahaBhumi Check: ${landInput > 0 ? 'PASS' : 'FAIL'})<br>
        • Input Annual Income: ₹ ${incomeInput.toLocaleString('en-IN')} (Revenue Cap Check: ${incomeInput <= 250000 ? 'PASS' : 'FAIL'})<br>
        <span style="color: ${isEligible ? '#4ADE80' : '#F87171'}; font-weight: bold;">
          Result: ${isEligible ? '✔ AUTO-ELIGIBLE (Fast-track Approved)' : '✖ INELIGIBLE (Rule Violation: Exceeds threshold)'}
        </span>
      `;
      consoleEl.scrollTop = consoleEl.scrollHeight;
    }
  }

  /* --------------------------------------------------------------------------
     SCREEN 21: REPORTS & ANALYTICS
     -------------------------------------------------------------------------- */
  function renderAdminAnalytics() {
    // Stats are driven by portalData.macroStats
  }

  /* --------------------------------------------------------------------------
     SCREEN 22: GUIDED END-TO-END DEMO TOUR
     -------------------------------------------------------------------------- */
  function renderDemoTour() {
    const stepper = document.getElementById('demo-tour-stepper');
    const currentStepBox = document.getElementById('demo-tour-current-step-box');
    if (!stepper || !currentStepBox) return;

    stepper.innerHTML = AppState.tour.steps.map((step, idx) => `
      <div class="tour-chip-step ${idx === AppState.tour.activeStepIndex ? 'active' : (idx < AppState.tour.activeStepIndex ? 'completed' : '')}" onclick="App.jumpToTourStep(${idx})">
        <span>${idx + 1}</span>
        <span>${step.title.split('. ')[1]}</span>
      </div>
    `).join('');

    const activeStep = AppState.tour.steps[AppState.tour.activeStepIndex];
    currentStepBox.innerHTML = `
      <div style="background: var(--bg-surface); border: 1px solid var(--border-color); border-radius: var(--radius-lg); padding: 1.5rem;">
        <span class="badge badge-warning" style="margin-bottom: 8px;">Stage ${AppState.tour.activeStepIndex + 1} of ${AppState.tour.steps.length}</span>
        <h3 style="font-size: 1.3rem; font-weight: 800; color: var(--gov-primary-dark);">${activeStep.title}</h3>
        <p style="font-size: 0.95rem; color: var(--text-secondary); margin: 8px 0 1.5rem;">${activeStep.desc}</p>
        <div style="display: flex; justify-content: space-between; align-items: center; border-top: 1px solid var(--border-color); padding-top: 1rem;">
          <button class="btn btn-secondary" onclick="App.prevTourStep()" ${AppState.tour.activeStepIndex === 0 ? 'disabled' : ''}>
            ◀ Previous Stage
          </button>
          <button class="btn btn-saffron" onclick="App.launchTourScreen('${activeStep.screen}')">
            Jump to Live Screen View ➔
          </button>
          <button class="btn btn-primary" onclick="App.nextTourStep()">
            ${AppState.tour.activeStepIndex === AppState.tour.steps.length - 1 ? 'Finish Tour ✔' : 'Next Stage ▶'}
          </button>
        </div>
      </div>
    `;
  }

  function nextTourStep() {
    if (AppState.tour.activeStepIndex < AppState.tour.steps.length - 1) {
      AppState.tour.activeStepIndex++;
      renderDemoTour();
      const targetScreen = AppState.tour.steps[AppState.tour.activeStepIndex].screen;
      if (AppState.tour.activeStepIndex === 9) switchRole('officer');
      else if (AppState.tour.activeStepIndex >= 10) switchRole('admin');
      else switchRole('citizen');
    } else {
      showToast('End-to-End Demonstration Completed!');
    }
  }

  function prevTourStep() {
    if (AppState.tour.activeStepIndex > 0) {
      AppState.tour.activeStepIndex--;
      renderDemoTour();
    }
  }

  function jumpToTourStep(idx) {
    AppState.tour.activeStepIndex = idx;
    renderDemoTour();
  }

  function launchTourScreen(screenId) {
    navigateToScreen(screenId);
  }

  /* --------------------------------------------------------------------------
     ACCESSIBILITY CONTROLS
     -------------------------------------------------------------------------- */
  function setupAccessibility() {
    if (elements.contrastToggle) {
      elements.contrastToggle.addEventListener('click', () => {
        document.body.classList.toggle('high-contrast');
        showToast('High Contrast Mode Toggled');
      });
    }

    if (elements.fontIncrease) {
      elements.fontIncrease.addEventListener('click', () => {
        if (!document.body.classList.contains('font-large')) {
          document.body.classList.add('font-large');
        } else {
          document.body.classList.remove('font-large');
          document.body.classList.add('font-xlarge');
        }
      });
    }

    if (elements.fontDecrease) {
      elements.fontDecrease.addEventListener('click', () => {
        document.body.classList.remove('font-xlarge');
        document.body.classList.remove('font-large');
      });
    }

    if (elements.fontReset) {
      elements.fontReset.addEventListener('click', () => {
        document.body.classList.remove('font-xlarge');
        document.body.classList.remove('font-large');
      });
    }
  }

  // Setup Event Listeners
  function setupEventListeners() {
    elements.roleSwitchBtns.forEach(btn => {
      btn.addEventListener('click', () => {
        const role = btn.getAttribute('data-role-switch');
        switchRole(role);
      });
    });

    elements.navItemBtns.forEach(btn => {
      btn.addEventListener('click', () => {
        const screen = btn.getAttribute('data-target-screen');
        if (screen) navigateToScreen(screen);
      });
    });

    if (elements.modalCloseBtn) {
      elements.modalCloseBtn.addEventListener('click', closeModal);
    }
    if (elements.modalBackdrop) {
      elements.modalBackdrop.addEventListener('click', (e) => {
        if (e.target === elements.modalBackdrop) closeModal();
      });
    }
  }

  // Public Interface for Inline HTML Handlers
  window.App = {
    init: function () {
      initElements();
      setupAccessibility();
      setupEventListeners();
      switchRole('citizen');
      renderScreen('screen-citizen-dashboard');
    },
    navigateToScreen,
    switchRole,
    trackApplication,
    openServiceDetails,
    startApplicationWizard,
    submitApplication,
    saveProfileChanges,
    toggleConsent,
    triggerLiveInterDeptSync,
    previewDocModal,
    openOfficerReview,
    officerAction,
    addBuilderField,
    removeBuilderField,
    testRuleSandbox,
    nextTourStep,
    prevTourStep,
    jumpToTourStep,
    launchTourScreen,
    showToast
  };

  // Bootstrap when DOM ready
  document.addEventListener('DOMContentLoaded', window.App.init);

})();
