import { createContext, useContext, useState, useCallback, type ReactNode } from 'react'
import { authApi } from '../api/authApi'

interface Tokens {
  idToken: string
  accessToken: string
  refreshToken: string
}

interface AuthContextValue {
  accessToken: string | null
  isAuthenticated: boolean
  login: (email: string, password: string) => Promise<void>
  logout: () => Promise<void>
  refresh: () => Promise<void>
}

const STORAGE_KEY = 'auth.tokens'

const AuthContext = createContext<AuthContextValue | undefined>(undefined)

function loadTokens(): Tokens | null {
  const raw = localStorage.getItem(STORAGE_KEY)
  return raw ? (JSON.parse(raw) as Tokens) : null
}

function saveTokens(tokens: Tokens | null) {
  if (tokens) {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(tokens))
  } else {
    localStorage.removeItem(STORAGE_KEY)
  }
}

export function AuthProvider({ children }: { children: ReactNode }) {
  const [tokens, setTokens] = useState<Tokens | null>(loadTokens)

  const login = useCallback(async (email: string, password: string) => {
    const result = await authApi.login(email, password)
    const next: Tokens = {
      idToken: result.idToken,
      accessToken: result.accessToken,
      refreshToken: result.refreshToken,
    }
    saveTokens(next)
    setTokens(next)
  }, [])

  const logout = useCallback(async () => {
    if (tokens) {
      await authApi.logout(tokens.accessToken).catch(() => undefined)
    }
    saveTokens(null)
    setTokens(null)
  }, [tokens])

  const refresh = useCallback(async () => {
    if (!tokens) return
    const result = await authApi.refresh(tokens.refreshToken)
    const next: Tokens = {
      idToken: result.idToken,
      accessToken: result.accessToken,
      refreshToken: tokens.refreshToken,
    }
    saveTokens(next)
    setTokens(next)
  }, [tokens])

  return (
    <AuthContext.Provider
      value={{
        accessToken: tokens?.accessToken ?? null,
        isAuthenticated: !!tokens,
        login,
        logout,
        refresh,
      }}
    >
      {children}
    </AuthContext.Provider>
  )
}

export function useAuth(): AuthContextValue {
  const ctx = useContext(AuthContext)
  if (!ctx) throw new Error('useAuth must be used within AuthProvider')
  return ctx
}
