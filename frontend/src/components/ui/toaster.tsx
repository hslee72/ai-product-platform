'use client';

import React, { createContext, useContext, useState, useCallback } from 'react';

type ToastType = {
  id: string;
  title?: string;
  description?: string;
  variant?: 'default' | 'destructive';
};

type ToastContextType = {
  toasts: ToastType[];
  toast: (toast: Omit<ToastType, 'id'>) => void;
  dismiss: (id: string) => void;
};

const ToastContext = createContext<ToastContextType | undefined>(undefined);

export function useToast() {
  const context = useContext(ToastContext);
  if (!context) {
    return {
      toasts: [] as ToastType[],
      toast: (_: Omit<ToastType, 'id'>) => {},
      dismiss: (_: string) => {},
    };
  }
  return context;
}

export function Toaster() {
  const [toasts, setToasts] = useState<ToastType[]>([]);

  const toast = useCallback((newToast: Omit<ToastType, 'id'>) => {
    const id = Math.random().toString(36).substring(2);
    setToasts((prev) => [...prev, { ...newToast, id }]);
    setTimeout(() => {
      setToasts((prev) => prev.filter((t) => t.id !== id));
    }, 3000);
  }, []);

  const dismiss = useCallback((id: string) => {
    setToasts((prev) => prev.filter((t) => t.id !== id));
  }, []);

  return (
    <ToastContext.Provider value={{ toasts, toast, dismiss }}>
      <div className="fixed bottom-0 right-0 z-50 p-4 flex flex-col gap-2">
        {toasts.map((t) => (
          <div
            key={t.id}
            className={`rounded-md p-4 shadow-md bg-white border ${
              t.variant === 'destructive' ? 'border-red-500' : 'border-gray-200'
            }`}
          >
            {t.title && <p className="font-semibold">{t.title}</p>}
            {t.description && <p className="text-sm">{t.description}</p>}
            <button onClick={() => dismiss(t.id)} className="absolute top-2 right-2 text-gray-400">
              x
            </button>
          </div>
        ))}
      </div>
    </ToastContext.Provider>
  );
}
