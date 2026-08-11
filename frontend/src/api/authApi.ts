const API_BASE_URL = import.meta.env.VITE_API_BASE_URL as string

export class ApiError extends Error {
  status: number
  constructor(status: number, message: string) {
    super(message)
    this.status = status
  }
}

async function request<T>(path: string, body?: unknown, token?: string): Promise<T> {
  const res = await fetch(`${API_BASE_URL}${path}`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
    },
    body: body !== undefined ? JSON.stringify(body) : undefined,
  })

  const data = await res.json().catch(() => ({}))

  if (!res.ok) {
    throw new ApiError(res.status, data.message ?? data.error ?? 'Request failed')
  }

  return data as T
}

export interface RegisterResponse {
  userSub: string
  userConfirmed: boolean
}

export interface LoginResponse {
  idToken: string
  accessToken: string
  refreshToken: string
  expiresIn: number
}

export interface RefreshResponse {
  idToken: string
  accessToken: string
  expiresIn: number
}

export interface MeResponse {
  sub: string
  email: string
}

export const authApi = {
  register: (email: string, password: string) =>
    request<RegisterResponse>('/auth/register', { email, password }),

  confirm: (email: string, code: string) =>
    request<{ message: string }>('/auth/confirm', { email, code }),

  resendConfirmation: (email: string) =>
    request<{ message: string }>('/auth/resend-confirmation', { email }),

  login: (email: string, password: string) =>
    request<LoginResponse>('/auth/login', { email, password }),

  refresh: (refreshToken: string) =>
    request<RefreshResponse>('/auth/refresh', { refreshToken }),

  forgotPassword: (email: string) =>
    request<{ message: string }>('/auth/forgot-password', { email }),

  confirmForgotPassword: (email: string, code: string, newPassword: string) =>
    request<{ message: string }>('/auth/confirm-forgot-password', { email, code, newPassword }),

  logout: (accessToken: string) =>
    request<{ message: string }>('/auth/logout', { accessToken }),

  me: (accessToken: string) =>
    fetch(`${API_BASE_URL}/auth/me`, {
      headers: { Authorization: `Bearer ${accessToken}` },
    }).then(async (res) => {
      const data = await res.json().catch(() => ({}))
      if (!res.ok) throw new ApiError(res.status, data.message ?? 'Request failed')
      return data as MeResponse
    }),
}
